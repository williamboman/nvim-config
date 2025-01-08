vim.cmd.packadd "mason.nvim"
require("mason").setup {
    registries = {
        ("file:%s"):format(vim.fn.stdpath("config")),
        "github:mason-org/mason-registry"
    }
}
vim.opt.packpath:prepend(vim.fn.expand("$MASON/opt"))
