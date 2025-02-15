vim.cmd.packadd "plenary.nvim"
vim.cmd.packadd "typescript-tools.nvim"

require("typescript-tools").setup {
    use_native_lsp_config = true,
    settings = {
        expose_as_code_action = "all"
    }
}
