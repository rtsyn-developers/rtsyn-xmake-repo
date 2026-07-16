includes(path.join(os.scriptdir(), "..", "..", "..", "includes", "rtsyn_source.lua"))
includes(path.join(os.scriptdir(), "..", "..", "..", "includes", "rtsyn_install.lua"))

local package_name = "rtsyn-node"

package(package_name)

set_homepage("https://github.com/rtsyn-developers/" .. package_name)
set_description("C library for creating a node for RTSyn")
set_license("GPL-3.0-or-later")

add_deps("rtsyn-abi 1.0.0", "rtsyn-value 1.0.0", "rtsyn-port 1.0.0", "rtsyn-collection 1.0.0")
rtsyn_source(package_name, "https://github.com/rtsyn-developers/" .. package_name .. ".git", "1.0.0")

rtsyn_install(package_name)

on_test(function(package)
	assert(package:has_cincludes("rtsyn/node.h"))
end)
