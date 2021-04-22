local tree_cb = require'nvim-tree.config'.nvim_tree_callback
local events = require'nvim-tree.events'

local M = {}

M.setup = function ()
    vim.g.nvim_tree_disable_keybindings = true
    vim.g.nvim_tree_icons = {
        default = '',
        symlink = '',
        git = {
            unstaged = "✗",
            staged = "✓",
            unmerged = "",
            renamed = "➜",
            untracked = "?"
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
        ["<CR>"]   =  tree_cb("edit"),
        ["o"]      =  tree_cb("edit"),
        ["<C-v>"]  =  tree_cb("vsplit"),
        ["s"]      =  tree_cb("vsplit"),
        ["<C-x>"]  =  tree_cb("split"),
        ["<C-t>"]  =  tree_cb("tabnew"),
        ["<S-t>"]  =  tree_cb("tabnew"),
        ["<BS>"]   =  tree_cb("close_node"),
        ["X"]      =  tree_cb("close_node"),
        ["<Tab>"]  =  tree_cb("preview"),
        ["r"]      =  tree_cb("refresh"),
        ["ma"]     =  tree_cb("create"),
        ["md"]     =  tree_cb("remove"),
        ["mm"]     =  tree_cb("rename"),
        ["<C-r>"]  =  tree_cb("full_rename"),
        ["x"]      =  tree_cb("cut"),
        ["c"]      =  tree_cb("copy"),
        ["p"]      =  tree_cb("paste"),
        ["[c"]     =  tree_cb("prev_git_item"),
        ["]c"]     =  tree_cb("next_git_item"),
        ["-"]      =  tree_cb("dir_up"),
        ["C"]      =  tree_cb("cd"),
    }

    vim.api.nvim_set_keymap('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', {noremap=true})
    vim.api.nvim_set_keymap('n', '<leader>a', '<cmd>NvimTreeFindFile<CR>', {noremap=true})

    events.on_node_renamed(function (payload)
        -- TODO: not do this when folder
        require'nvim-lsp-installer.extras.tsserver'.rename_file(payload.old_name, payload.new_name)
    end)
end

return M
