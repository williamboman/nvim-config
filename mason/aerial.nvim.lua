vim.cmd.packadd("aerial.nvim")
require("aerial").setup({
    on_attach = function(bufnr)
        vim.keymap.set("n", "[s", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "8s", "[s", { buffer = bufnr, remap = true })
        vim.keymap.set("n", "]s", "<cmd>AerialNext<CR>", { buffer = bufnr })
        vim.keymap.set("n", "9s", "]s", { buffer = bufnr, remap = true })
    end,
})
vim.keymap.set("n", "<space>s", "<cmd>AerialToggle<cr>")
