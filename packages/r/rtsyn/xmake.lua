includes(path.join(os.scriptdir(), "..", "..", "..", "includes", "rtsyn_source.lua"))
includes(path.join(os.scriptdir(), "..", "..", "..", "includes", "rtsyn_cargo.lua"))

local package_name = "rtsyn"
local native_dependencies = {
	"rtsyn-api",
	"rtsyn-engine",
	"rtsyn-runtime",
	"rtsyn-thread",
	"rtsyn-spsc",
	"rtsyn-node",
	"rtsyn-port",
	"rtsyn-value",
	"rtsyn-abi",
	"rtsyn-collection",
	"rtsyn-module-loader",
	"rtsyn-measurement-tool",
	"rtsyn-defaults",
	"cpp-httplib",
	"libuv",
}

package(package_name)

set_homepage("https://github.com/rtsyn-developers/" .. package_name)
set_description("RTSyn launcher that starts the GUI or CLI frontend")
set_license("GPL-3.0-or-later")

add_configs("thread_core", {
	default = "posix",
	values = { "posix", "preempt_rt", "xenomai" },
	description = "Thread core backend"
})

on_load(function(package)
	local thread_core = package:config("thread_core")
	package:add("deps", "rtsyn-ui 1.0.0", { configs = { thread_core = thread_core } })
	package:add("deps", "rtsyn-engine 1.0.0", { configs = { thread_core = thread_core, package_layout = "library" } })
	package:add("deps", "rtsyn-runtime 1.0.0", { configs = { thread_core = thread_core } })
	package:add("deps", "rtsyn-thread 1.0.0", { configs = { thread_core = thread_core } })
	package:add("deps", "rtsyn-api 1.0.0", { configs = { package_layout = "library" } })
	package:add("deps", "rtsyn-spsc 1.0.0")
	package:add("deps", "rtsyn-node 1.0.0")
	package:add("deps", "rtsyn-port 1.0.0")
	package:add("deps", "rtsyn-value 1.0.0")
	package:add("deps", "rtsyn-abi 1.0.0")
	package:add("deps", "rtsyn-collection 1.0.0")
	package:add("deps", "rtsyn-module-loader 1.0.0")
	package:add("deps", "rtsyn-measurement-tool 1.0.0")
	package:add("deps", "rtsyn-defaults 1.0.0")
	package:add("deps", "cpp-httplib")
	package:add("deps", "libuv")
end)

rtsyn_source(package_name, "https://github.com/rtsyn-developers/" .. package_name .. ".git", "1.0.0")

local function append_unique(values, value)
	if value and value ~= "" and os.isdir(value) then
		for _, existing in ipairs(values) do
			if existing == value then
				return
			end
		end
		table.insert(values, value)
	end
end

local function append_fetched_paths(values, dep, field)
	local info = dep:fetch()
	if not info or not info[field] then
		return
	end

	for _, value in ipairs(info[field]) do
		append_unique(values, value)
	end
end

local function package_paths(package, scope)
	local values = {}
	for _, dep_name in ipairs(native_dependencies) do
		local dep = package:dep(dep_name)
		if dep then
			append_unique(values, path.join(dep:installdir(), scope))
			if scope == "include" then
				append_fetched_paths(values, dep, "includedirs")
			elseif scope == "lib" then
				append_fetched_paths(values, dep, "linkdirs")
			end
		end
	end
	return table.concat(values, path.envsep())
end

local function cargo_envs(package)
	return {
		RTSYN_NATIVE_INCLUDE_DIRS = package_paths(package, "include"),
		RTSYN_NATIVE_LIB_DIRS = package_paths(package, "lib"),
		RTSYN_NATIVE_LIBS = "rtsyn-api,rtsyn-engine,rtsyn-runtime,rtsyn-spsc,rtsyn-node,rtsyn-port,rtsyn-value,rtsyn-abi,rtsyn-collection,rtsyn-module-loader,rtsyn-measurement-tool,rtsyn-thread,uv",
	}
end

rtsyn_cargo_install_binary(package_name, package_name, { "--bin", package_name }, {
	envs = cargo_envs,
	workspace_patches = {
		{
			package_name = "rtsyn-ui",
			remote_url = "https://github.com/rtsyn-developers/rtsyn-ui.git"
		}
	}
})

on_test(function(package)
	assert(os.isfile(path.join(package:installdir("bin"), "rtsyn")))
end)
