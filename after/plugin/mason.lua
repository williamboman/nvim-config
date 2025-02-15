vim.opt.packpath:prepend(vim.fn.expand("$MASON/opt"))

local registry = require("mason-registry")

local function ends_with(str, ending)
    return ending == "" or string.sub(str, - #ending) == ending
end

local profiling = {}

local function runtime(prefix, pkg)
    local start = { vim.loop.gettimeofday() }
    xpcall(function()
        if ends_with(pkg, ".lua") then
            vim.cmd.runtime { prefix .. pkg, bang = true }
        end
        if ends_with(pkg, ".vim") then
            vim.cmd.runtime { prefix .. pkg, bang = true }
        end
        vim.cmd.runtime { prefix .. pkg .. ".lua", bang = true }
        vim.cmd.runtime { prefix .. pkg .. ".vim", bang = true }
    end, vim.api.nvim_err_writeln)
    local stop = { vim.loop.gettimeofday() }
    profiling[pkg] = { start, stop }
end

local executed_runtimes = {}

local function runtime_once(prefix, pkg)
    if executed_runtimes[pkg] then
        vim.notify_once(pkg .. " has already been sourced, restart Neovim.")
        return
    end
    executed_runtimes[pkg] = true
    return runtime(prefix, pkg)
end

local function lspconfig(pkg)
    local lspconfig_path = vim.fn.expand(("$MASON/share/mason/lspconfig/%s.json"):format(pkg))
    if vim.uv.fs_access(lspconfig_path, "r") then
        local fd = assert(vim.uv.fs_open(lspconfig_path, "r", 438))
        local stat = assert(vim.uv.fs_fstat(fd))
        local data = assert(vim.uv.fs_read(fd, stat.size, 0))
        assert(vim.uv.fs_close(fd))
        vim.lsp.config(pkg, vim.json.decode(data))
        vim.lsp.enable(pkg)
    end
end

local start = { vim.uv.gettimeofday() }
for _, pkg_name in ipairs(registry.get_installed_package_names()) do
    runtime_once("mason/", pkg_name)
    lspconfig(pkg_name)
end
local stop = { vim.uv.gettimeofday() }
profiling["All"] = { start, stop }

registry:on("package:install:success", vim.schedule_wrap(function(pkg)
    lspconfig(pkg.name)
    -- runtime("mason/setup/", pkg.name)
    runtime_once("mason/", pkg.name)
end))

local function to_ms(pair)
    return pair[1] * 1000 + pair[2] / 1000
end

vim.api.nvim_create_user_command("MasonProfile", function(args)
    for pkg, profile in pairs(profiling) do
        if pkg ~= "All" then
            print(pkg, "took", to_ms(profile[2]) - to_ms(profile[1]), "ms")
        end
    end
    print("")
    print("All took", to_ms(profiling.All[2]) - to_ms(profiling.All[1]), "ms")
end, {nargs = 0})
