includes(path.join(os.scriptdir(), "..", "..", "..", "includes", "rtsyn_source.lua"))
includes(path.join(os.scriptdir(), "..", "..", "..", "includes", "rtsyn_install.lua"))

local package_name = "rtsyn-runtime"

package(package_name)

set_homepage("https://github.com/rtsyn-developers/" .. package_name)
set_description("C library that implements the runtime for RTSyn")
set_license("GPL-3.0-or-later")

add_configs("thread_core", {
	default = "posix",
	values = { "posix", "preempt_rt", "xenomai" },
	description = "Thread core backend"
})

add_deps("rtsyn-port 1.0.0", "rtsyn-node 1.0.0", "rtsyn-collection 1.0.0", "rtsyn-abi 1.0.0", "rtsyn-value 1.0.0",
         "rtsyn-defaults 1.0.0")
on_load(function(package)
	package:add("deps", "rtsyn-thread 1.0.0", { configs = { thread_core = package:config("thread_core") } })
end)
rtsyn_source(package_name, "https://github.com/rtsyn-developers/" .. package_name .. ".git", "1.0.0")

rtsyn_install(package_name, {
	thread_core = function(package)
		return package:config("thread_core")
	end
})

on_test(function(package)
	assert(package:has_cincludes("rtsyn/runtime.h"))
end)
