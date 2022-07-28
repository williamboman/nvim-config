local ok, lsp_lines = pcall(require, "lsp_lines")
if not ok then
    return
end

lsp_lines.setup()

-- Default config
vim.diagnostic.config {
    virtual_lines = false,
    signs = false,
    float = {
        header = false,
        source = "always",
    },
}

vim.keymap.set(
    "n",
    "<M-d>",
    require("lsp_lines").toggle,
    { desc = "Toggle lsp_lines" }
)
