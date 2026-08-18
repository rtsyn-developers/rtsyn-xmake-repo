includes(path.join(os.scriptdir(), "..", "..", "..", "includes", "rtsyn_source.lua"))
includes(path.join(os.scriptdir(), "..", "..", "..", "includes", "rtsyn_install.lua"))

local package_name = "rtsyn-defaults"

package(package_name)

set_homepage("https://github.com/rtsyn-developers/" .. package_name)
set_description("Header-only shared default values for RTSyn modules")
set_license("GPL-3.0-or-later")

rtsyn_source(package_name, "https://github.com/rtsyn-developers/" .. package_name .. ".git")

rtsyn_install(package_name)

on_test(function(package)
	assert(package:has_cincludes("rtsyn/api/defaults.h"))
	assert(package:has_cincludes("rtsyn/engine/defaults.h"))
	assert(package:has_cincludes("rtsyn/runtime/defaults.h"))
	assert(package:has_cincludes("rtsyn/spsc/defaults.h"))
end)
