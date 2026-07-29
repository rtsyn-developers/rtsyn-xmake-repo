includes(path.join(os.scriptdir(), "..", "..", "..", "includes", "rtsyn_source.lua"))
includes(path.join(os.scriptdir(), "..", "..", "..", "includes", "rtsyn_install.lua"))

local package_name = "rtsyn-mock"

package(package_name)

set_homepage("https://github.com/rtsyn-developers/" .. package_name)
set_description("C library for creating mock structures for RTSyn testing")
set_license("GPL-3.0-or-later")

add_deps("rtsyn-abi")
rtsyn_source(package_name, "https://github.com/rtsyn-developers/" .. package_name .. ".git")

on_install(function(package)
	import("package.tools.xmake", { alias = "xmake" })

	local envs = xmake.buildenvs(package)
	envs.XMAKE_CONFIGDIR = path.join(package:builddir(), ".xmake")

	xmake.install(package, { tests = false }, { envs = envs })
end)

on_test(function(package)
	assert(package:has_cincludes("rtsyn/mock/module_loader/node.h"))
end)
