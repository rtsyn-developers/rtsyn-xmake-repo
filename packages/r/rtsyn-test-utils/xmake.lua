includes(path.join(os.scriptdir(), "..", "..", "..", "includes", "rtsyn_source.lua"))

local package_name = "rtsyn-test-utils"
local repo_name = "rtsyn-xmake-repo"

package(package_name)

set_homepage("https://github.com/rtsyn-developers/" .. repo_name)
set_description("Shared testing rules for RTSyn projects")
set_license("GPL-3.0-or-later")

rtsyn_source(repo_name, "https://github.com/rtsyn-developers/" .. repo_name .. ".git", "1.0.0")

on_install(function(package) end)
