vim.cmd.packadd "oil.nvim"
require("oil").setup()

vim.keymap.set("n", "<leader>a", vim.cmd.Oil)
