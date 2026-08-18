function rtsyn_install(package_name, configs, opt)
	configs = configs or {}
	opt = opt or {}

	on_install(function(package)
		import("package.tools.xmake", { alias = "xmake" })

		local install_configs = table.clone(configs)
		local install_opt = table.clone(opt)

		for name, value in pairs(install_configs) do
			if type(value) == "function" then
				install_configs[name] = value(package)
			end
		end

		if install_configs.tests == nil then
			install_configs.tests = "n"
		elseif type(install_configs.tests) == "boolean" then
			install_configs.tests = install_configs.tests and "y" or "n"
		end
		if install_configs.mode == nil then
			install_configs.mode = "release"
		end

		local envs = xmake.buildenvs(package)
		envs.XMAKE_CONFIGDIR = path.join(package:builddir(), ".xmake")

		install_opt.target = install_opt.target or package_name
		install_opt.envs = install_opt.envs or envs

		xmake.install(package, install_configs, install_opt)
	end)
end
