includes(path.join(os.scriptdir(), "..", "..", "..", "includes", "rtsyn_source.lua"))
includes(path.join(os.scriptdir(), "..", "..", "..", "includes", "rtsyn_install.lua"))

local package_name = "rtsyn-engine"

package(package_name)

set_homepage("https://github.com/rtsyn-developers/" .. package_name)
set_description("C library that runs an RTSyn runtime with command and telemetry SPSC queues")
set_license("GPL-3.0-or-later")

add_configs("thread_core", {
	default = "posix",
	values = { "posix", "preempt_rt", "xenomai" },
	description = "Thread core backend"
})
add_configs("package_layout", {
	default = "library",
	values = { "library" },
	description = "Installed package layout"
})

add_deps("rtsyn-spsc", "rtsyn-defaults", "rtsyn-measurement-tool", "rtsyn-module-loader")
on_load(function(package)
	local thread_core = package:config("thread_core")
	package:add("deps", "rtsyn-runtime", { configs = { thread_core = thread_core } })
	package:add("deps", "rtsyn-thread", { configs = { thread_core = thread_core } })
end)
rtsyn_source(package_name, "https://github.com/rtsyn-developers/" .. package_name .. ".git")

rtsyn_install(package_name, {
	thread_core = function(package)
		return package:config("thread_core")
	end
})

on_test(function(package)
	assert(package:has_cincludes("rtsyn/engine.h"))
end)
