includes(path.join(os.scriptdir(), "..", "..", "..", "includes", "rtsyn_source.lua"))
includes(path.join(os.scriptdir(), "..", "..", "..", "includes", "rtsyn_install.lua"))

local package_name = "rtsyn-module-loader"

package(package_name)

set_homepage("https://github.com/rtsyn-developers/" .. package_name)
set_description("C library for loading a module for RTSyn")
set_license("GPL-3.0-or-later")

add_deps("rtsyn-abi 1.0.0", "libuv")
rtsyn_source(package_name, "https://github.com/rtsyn-developers/" .. package_name .. ".git", "1.0.0")

rtsyn_install(package_name)

on_test(function(package)
	assert(package:has_cincludes("rtsyn/module_loader.h"))
end)
