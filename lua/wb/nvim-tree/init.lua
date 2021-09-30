local tree_cb = require("nvim-tree.config").nvim_tree_callback

local M = {}

M.setup = function()
    vim.g.nvim_tree_disable_keybindings = true
    vim.g.nvim_tree_disable_default_keybindings = true
    vim.g.nvim_tree_icons = {
        default = "",
        symlink = "",
        git = {
            unstaged = "✗",
            staged = "✓",
            unmerged = "",
            renamed = "➜",
            untracked = "?",
        },
        folder = {
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
            symlink_open = "",
        },
    }

    vim.g.nvim_tree_bindings = {
        { key = { "<CR>" }, cb = tree_cb "edit" },
        { key = { "o" }, cb = tree_cb "edit" },
        { key = { "<C-v>" }, cb = tree_cb "vsplit" },
        { key = { "s" }, cb = tree_cb "vsplit" },
        { key = { "<C-x>" }, cb = tree_cb "split" },
        { key = { "t" }, cb = tree_cb "tabnew" },
        { key = { "<BS>" }, cb = tree_cb "close_node" },
        { key = { "X" }, cb = tree_cb "close_node" },
        { key = { "<Tab>" }, cb = tree_cb "preview" },
        { key = { "r" }, cb = tree_cb "refresh" },
        { key = { "ma" }, cb = tree_cb "create" },
        { key = { "md" }, cb = tree_cb "remove" },
        { key = { "mm" }, cb = tree_cb "rename" },
        { key = { "x" }, cb = tree_cb "cut" },
        { key = { "c" }, cb = tree_cb "copy" },
        { key = { "p" }, cb = tree_cb "paste" },
        { key = { "[c" }, cb = tree_cb "prev_git_item" },
        { key = { "]c" }, cb = tree_cb "next_git_item" },
        { key = { "-" }, cb = tree_cb "dir_up" },
        { key = { "C" }, cb = tree_cb "cd" },
    }

    vim.api.nvim_set_keymap("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { noremap = true })
    vim.api.nvim_set_keymap("n", "<leader>a", "<cmd>NvimTreeFindFile<CR>", { noremap = true })

    require("nvim-lsp-installer.adapters.nvim-tree").connect()
end

return M
