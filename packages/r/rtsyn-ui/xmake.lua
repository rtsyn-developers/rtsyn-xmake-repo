includes(path.join(os.scriptdir(), "..", "..", "..", "includes", "rtsyn_source.lua"))
includes(path.join(os.scriptdir(), "..", "..", "..", "includes", "rtsyn_cargo.lua"))

local package_name = "rtsyn-ui"

package(package_name)

set_homepage("https://github.com/rtsyn-developers/" .. package_name)
set_description("Rust RTSyn client library containing the CLI and GUI frontends")
set_license("GPL-3.0-or-later")

add_configs("thread_core", {
	default = "posix",
	values = { "posix", "preempt_rt", "xenomai" },
	description = "Thread core backend"
})

rtsyn_source(package_name, "https://github.com/rtsyn-developers/" .. package_name .. ".git", "1.0.0")

rtsyn_cargo_install_package(package_name, { "--lib" })
rtsyn_cargo_test(package_name, { "--lib" })
