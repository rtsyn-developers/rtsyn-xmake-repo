includes(path.join(os.scriptdir(), "..", "..", "..", "includes", "rtsyn_source.lua"))
includes(path.join(os.scriptdir(), "..", "..", "..", "includes", "rtsyn_install.lua"))

local package_name = "rtsyn-node"

package(package_name)

set_homepage("https://github.com/rtsyn-developers/" .. package_name)
set_description("C library for creating a node for RTSyn")
set_license("GPL-3.0-or-later")

add_deps("rtsyn-abi", "rtsyn-value", "rtsyn-port", "rtsyn-collection")
rtsyn_source(package_name, "https://github.com/rtsyn-developers/" .. package_name .. ".git")

rtsyn_install(package_name)

on_test(function(package)
	assert(package:has_cincludes("rtsyn/node.h"))
end)
