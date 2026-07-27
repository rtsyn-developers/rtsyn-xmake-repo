rule("loadable_package")
on_config(function(target)
	import("core.project.project")

	local rule_name = "@rtsyn-test-utils/loadable_package"
	local define = target:extraconf("rules", rule_name, "define") or "RTSYN_TEST_MODULE_PATH"
	local package_name = target:extraconf("rules", rule_name, "package")
	local target_name = target:extraconf("rules", rule_name, "target")

	assert(package_name or target_name, "loadable_package requires a package or target name")
	assert(not (package_name and target_name), "loadable_package accepts either package or target, not both")

	local libraryfile
	if target_name then
		local dependency = assert(target:dep(target_name), "target(%s) is not a dependency", target_name)
		libraryfile = path.absolute(dependency:targetfile(), os.projectdir())
	else
		local package = assert(project.required_package(package_name), "package(%s) is not required", package_name)
		local filename = target:extraconf("rules", rule_name, "filename")
		local directory = "lib"
		if not filename then
			if is_plat("windows") then
				directory = "bin"
				filename = package_name .. ".dll"
			elseif is_plat("macosx") then
				filename = "lib" .. package_name .. ".dylib"
			else
				filename = "lib" .. package_name .. ".so"
			end
		end
		libraryfile = path.join(package:installdir(), directory, filename)
	end

	libraryfile = libraryfile:replace("\\", "/")
	target:add("defines", define .. '=\"' .. libraryfile .. '\"')
end)
rule_end()
