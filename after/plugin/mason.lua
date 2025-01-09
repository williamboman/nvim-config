local registry = require("mason-registry")

local function source_runtime(pkg)
    xpcall(function ()
        vim.cmd.runtime { ("mason/%s.lua"):format(pkg), bang = true }
        vim.cmd.runtime { ("mason/%s.vim"):format(pkg), bang = true }
    end, vim.api.nvim_err_writeln)
end

for _, pkg in ipairs(registry.get_installed_package_names()) do
    source_runtime(pkg)
end

registry:on("package:install:success", vim.schedule_wrap(function (pkg)
    source_runtime(pkg.name)
end))
