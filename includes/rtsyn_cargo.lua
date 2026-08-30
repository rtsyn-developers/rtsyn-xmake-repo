local function rtsyn_cargo_manifest(package, package_name)
	local candidates = {}

	if package:sourcedir() then
		table.insert(candidates, path.join(package:sourcedir(), "Cargo.toml"))
	end

	if package:cachedir() then
		table.insert(candidates, path.join(package:cachedir(), "source", package_name, "Cargo.toml"))
	end

	table.insert(candidates, path.join(os.curdir(), "Cargo.toml"))

	for _, candidate in ipairs(candidates) do
		if os.isfile(candidate) then
			return candidate
		end
	end

	raise(package_name .. " Cargo.toml not found")
end

local function rtsyn_cargo_target_dir(package)
	return path.join(package:builddir(), "cargo-target")
end

local function rtsyn_cargo_artifact(package, binary_name)
	local binary_suffix = ""
	if package:is_plat("windows") then
		binary_suffix = ".exe"
	end

	local candidate = path.join(rtsyn_cargo_target_dir(package), "release", binary_name .. binary_suffix)
	if os.isfile(candidate) then
		return candidate
	end

	raise("failed to locate Cargo artifact: " .. candidate)
end

local function rtsyn_cargo_add_workspace_git_patch(args, patch_config)
	local workspace = os.getenv("RTSYN_WORKSPACE")
	if workspace and patch_config then
		table.insert(args, "--config")
		table.insert(args,
			"patch.\"" .. patch_config.remote_url .. "\"." .. patch_config.package_name .. ".path=\"" ..
			path.join(workspace, patch_config.package_name) .. "\""
		)
	end
end

local function rtsyn_cargo_build_args(package, package_name, cargo_args, opt)
	cargo_args = cargo_args or {}
	opt = opt or {}

	local args = {
		"build",
		"--release",
		"--manifest-path",
		rtsyn_cargo_manifest(package, package_name),
		"--target-dir",
		rtsyn_cargo_target_dir(package)
	}

	for _, patch_config in ipairs(opt.workspace_patches or {}) do
		rtsyn_cargo_add_workspace_git_patch(args, patch_config)
	end

	for _, arg in ipairs(cargo_args) do
		table.insert(args, arg)
	end

	return args
end

local function rtsyn_cargo_envs(package, opt)
	opt = opt or {}
	if type(opt.envs) == "function" then
		return opt.envs(package)
	end
	return opt.envs
end

local function rtsyn_cargo_test_args(package, package_name, cargo_args, opt)
	cargo_args = cargo_args or {}
	opt = opt or {}

	local args = {
		"test",
		"--manifest-path",
		rtsyn_cargo_manifest(package, package_name),
		"--target-dir",
		rtsyn_cargo_target_dir(package)
	}

	for _, patch_config in ipairs(opt.workspace_patches or {}) do
		rtsyn_cargo_add_workspace_git_patch(args, patch_config)
	end

	for _, arg in ipairs(cargo_args) do
		table.insert(args, arg)
	end

	return args
end

function rtsyn_cargo_install_package(package_name, cargo_args, opt)
	on_install(function(package)
		os.vrunv("cargo", rtsyn_cargo_build_args(package, package_name, cargo_args, opt), {
			envs = rtsyn_cargo_envs(package, opt)
		})
	end)
end

function rtsyn_cargo_install_binary(package_name, binary_name, cargo_args, opt)
	opt = opt or {}

	on_install(function(package)
		os.vrunv("cargo", rtsyn_cargo_build_args(package, package_name, cargo_args, opt), {
			envs = rtsyn_cargo_envs(package, opt)
		})
		os.mkdir(package:installdir("bin"))
		os.cp(rtsyn_cargo_artifact(package, binary_name), path.join(package:installdir("bin"), binary_name))
	end)
end

function rtsyn_cargo_test(package_name, cargo_args, opt)
	on_test(function(package)
		os.vrunv("cargo", rtsyn_cargo_test_args(package, package_name, cargo_args, opt))
	end)
end
