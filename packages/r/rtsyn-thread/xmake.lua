includes(path.join(os.scriptdir(), "..", "..", "..", "includes", "rtsyn_source.lua"))
includes(path.join(os.scriptdir(), "..", "..", "..", "includes", "rtsyn_install.lua"))

local package_name = "rtsyn-thread"

package(package_name)

set_homepage("https://github.com/rtsyn-developers/" .. package_name)
set_description("C library for creating a thread for RTSyn")
set_license("GPL-3.0-or-later")

add_configs("thread_core", {
	default = "posix",
	values = { "posix", "preempt_rt", "xenomai" },
	description = "Thread core backend"
})

-- PREEMPT_RT source consumes the engine QoS default from this package.
add_deps("rtsyn-defaults")

rtsyn_source(package_name, "https://github.com/rtsyn-developers/" .. package_name .. ".git")

rtsyn_install(package_name, {
	thread_core = function(package)
		return package:config("thread_core")
	end
})

on_test(function(package)
	assert(package:has_cincludes("rtsyn/thread.h"))
end)
