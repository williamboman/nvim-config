vim.g["test#strategy"] = "neovim"
vim.g["test#neovim#term_position"] = "vsplit"

vim.api.nvim_set_keymap("n", "<space>r", "<cmd>TestNearest<CR>", { noremap = false })
