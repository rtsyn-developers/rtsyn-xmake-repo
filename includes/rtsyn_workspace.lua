-- Build native sibling repositories for aggregate RTSyn workspace targets.

local native_modules = {
    "rtsyn-abi",
    "rtsyn-defaults",
    "rtsyn-collection",
    "rtsyn-value",
    "rtsyn-port",
    "rtsyn-node",
    "rtsyn-thread",
    "rtsyn-spsc",
    "rtsyn-module-loader",
    "rtsyn-measurement-tool",
    "rtsyn-runtime",
    "rtsyn-engine",
    "rtsyn-api",
}

local thread_core_modules = {
    ["rtsyn-thread"] = true,
    ["rtsyn-runtime"] = true,
    ["rtsyn-engine"] = true,
}

function main(workspace, mode, thread_core, external_includes)
    assert(workspace and workspace ~= "", "workspace path is required")
    mode = mode or "release"
    thread_core = thread_core or "posix"

    local common_envs = { RTSYN_WORKSPACE = workspace }
    local include_dirs = {}
    for _, name in ipairs(native_modules) do
        local include_dir = path.join(workspace, name, "include")
        if os.isdir(include_dir) then
            table.insert(include_dirs, include_dir)
        end
    end
    local workspace_includes = table.concat(include_dirs, path.envsep())
    if external_includes and external_includes ~= "" then
        workspace_includes = workspace_includes .. path.envsep() .. external_includes
    end

    for _, name in ipairs(native_modules) do
        local project_dir = path.join(workspace, name)
        local project_file = path.join(project_dir, "xmake.lua")
        if not os.isfile(project_file) then
            raise("workspace module '%s' is missing %s", name, project_file)
        end

        local config_args = {
            "f", "-y", "-m", mode, "--tests=n",
            "--includedirs=" .. workspace_includes,
        }
        if thread_core_modules[name] then
            table.insert(config_args, "--thread_core=" .. thread_core)
        end

        cprint("${bright cyan}workspace: configuring %s", name)
        os.vrunv(os.programfile(), config_args,
                 { envs = common_envs, curdir = project_dir })
        cprint("${bright cyan}workspace: building %s", name)
        os.vrunv(os.programfile(), { "build", name },
                 { envs = common_envs, curdir = project_dir })
    end
end
