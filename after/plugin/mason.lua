local registry = require("mason-registry")

for _, pkg in ipairs(registry.get_installed_package_names()) do
    xpcall(function ()
        vim.cmd.runtime { ("mason/%s.{lua,vim}"):format(pkg), bang = true }
    end, vim.api.nvim_err_writeln)
end
