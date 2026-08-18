includes(path.join(os.scriptdir(), "..", "..", "..", "includes", "rtsyn_source.lua"))
includes(path.join(os.scriptdir(), "..", "..", "..", "includes", "rtsyn_install.lua"))

local package_name = "rtsyn-api"

package(package_name)

set_homepage("https://github.com/rtsyn-developers/" .. package_name)
set_description("C++ HTTP bridge for RTSyn command and telemetry SPSC queues")
set_license("GPL-3.0-or-later")

add_configs("package_layout", {
	default = "library",
	values = { "library" },
	description = "Installed package layout"
})

add_deps("rtsyn-spsc 1.0.0", "rtsyn-defaults 1.0.0", "cpp-httplib")
rtsyn_source(package_name, "https://github.com/rtsyn-developers/" .. package_name .. ".git", "1.0.0")

rtsyn_install(package_name)

on_test(function(package)
	assert(package:has_cxxincludes("rtsyn/api.hpp", {
		configs = { languages = "c++23" },
	}))
end)
