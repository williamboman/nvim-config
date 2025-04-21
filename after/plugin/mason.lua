local _ = require("mason-core.functional")
vim.opt.packpath:prepend(vim.fn.expand("$MASON/opt"))

local registry = require("mason-registry")

local function ends_with(str, ending)
    return ending == "" or string.sub(str, - #ending) == ending
end

local function runtime(prefix, pkg)
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
    do return end
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

local function init(pkg_name)
    runtime_once("mason/", pkg_name)
    lspconfig(pkg_name)
end

_.each(init, registry.get_installed_package_names())

registry:on("package:install:success", vim.schedule_wrap(_.compose(init, _.prop "name")))

local function to_ms(pair)
    return pair[1] * 1000 + pair[2] / 1000
end
