local tree_cb = require("nvim-tree.config").nvim_tree_callback

local M = {}

M.setup = function()
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

    vim.api.nvim_set_keymap("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { noremap = true })
    vim.api.nvim_set_keymap("n", "<leader>a", "<cmd>NvimTreeFindFile<CR>", { noremap = true })

    require("nvim-tree").setup {
        diagnostics = {
            enable = true,
        },
        view = {
            width = 40,
            mappings = {
                custom_only = true,
                list = {
                    { key = { "<CR>" }, cb = tree_cb "edit" },
                    { key = { "o" }, cb = tree_cb "edit" },
                    { key = { "<C-v>" }, cb = tree_cb "vsplit" },
                    { key = { "<C-x>" }, cb = tree_cb "split" },
                    { key = { "T" }, cb = tree_cb "tabnew" },
                    { key = { "t" }, cb = tree_cb "tabnew" },
                    { key = { "X" }, cb = tree_cb "close_node" },
                    { key = { "<Tab>" }, cb = tree_cb "preview" },
                    { key = { "r" }, cb = tree_cb "refresh" },
                    { key = { "ma" }, cb = tree_cb "create" },
                    { key = { "md" }, cb = tree_cb "remove" },
                    { key = { "mm" }, cb = tree_cb "rename" },
                    { key = { "x" }, cb = tree_cb "cut" },
                    { key = { "c" }, cb = tree_cb "copy" },
                    { key = { "p" }, cb = tree_cb "paste" },
                    { key = { "Y" }, cb = tree_cb "copy_absolute_path"},
                    { key = { "[c" }, cb = tree_cb "prev_git_item" },
                    { key = { "]c" }, cb = tree_cb "next_git_item" },
                    { key = { "-" }, cb = tree_cb "dir_up" },
                    { key = { "C" }, cb = tree_cb "cd" },
                    { key = { "q" }, cb = tree_cb "close" },
                },
            },
        },
    }
    require("nvim-tree.events").on_node_renamed(function(payload)
        local old_uri = vim.uri_from_fname(payload.old_name)
        local new_uri = vim.uri_from_fname(payload.new_name)

        for _, client in pairs(vim.lsp.get_active_clients()) do
            if client.name == "tsserver" then
                client.request("workspace/executeCommand", {
                    command = "_typescript.applyRenameFile",
                    arguments = {
                        {
                            sourceUri = old_uri,
                            targetUri = new_uri,
                        },
                    },
                })
            end
        end
    end)
end

return M
