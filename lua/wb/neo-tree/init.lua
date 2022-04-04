local M = {}

function M.setup()
    require("neo-tree").setup {
        close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        default_component_configs = {
            indent = {
                indent_size = 2,
                padding = 1, -- extra padding on left hand side
                -- indent guides
                with_markers = true,
                indent_marker = "│",
                last_indent_marker = "└",
                highlight = "NeoTreeIndentMarker",
                -- expander config, needed for nesting files
                with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
                expander_collapsed = "",
                expander_expanded = "",
                expander_highlight = "NeoTreeExpander",
            },
            icon = {
                folder_closed = "",
                folder_open = "",
                folder_empty = "ﰊ",
                default = "*",
            },
            modified = {
                symbol = "[+]",
                highlight = "NeoTreeModified",
            },
            name = {
                trailing_slash = true,
                use_git_status_colors = true,
            },
            git_status = {
                symbols = {
                    -- Change type
                    added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
                    modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
                    deleted = "✖", -- this can only be used in the git_status source
                    renamed = "", -- this can only be used in the git_status source
                    -- Status type
                    untracked = "?",
                    ignored = "",
                    unstaged = "M",
                    staged = "",
                    conflict = "",
                },
            },
        },
        window = {
            position = "left",
            width = 40,
            mappings = {
                ["<CR>"] = "open",
                ["o"] = "open",
                ["<C-v>"] = "open_vsplit",
                ["<C-x>"] = "open_split",
                ["t"] = "open_tabnew",
                ["T"] = "open_tabnew",
                ["X"] = "close_node",
                ["-"] = "navigate_up",
                ["C"] = "set_root",
                ["H"] = "toggle_hidden",
                ["r"] = "refresh",
                ["/"] = "fuzzy_finder",
                ["f"] = "filter_on_submit",
                ["<c-f>"] = "clear_filter",
                ["ma"] = "add",
                ["md"] = "delete",
                ["mr"] = "rename",
                ["y"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["p"] = "paste_from_clipboard",
                ["q"] = "close_window",
                -- reset default mappings
                ["space"] = "",
                ["<2-LeftMouse>"] = "",
                ["S"] = "",
                ["s"] = "",
                ["<bs>"] = "",
                ["."] = "",
            },
        },
        nesting_rules = {},
        filesystem = {
            filtered_items = {
                visible = true,
                hide_dotfiles = true,
                hide_gitignored = true,
                hide_by_name = {
                    ".DS_Store",
                    "thumbs.db",
                },
                never_show = { -- remains hidden even if visible is toggled to true
                },
            },
            follow_current_file = false, -- This will find and focus the file in the active buffer every
            -- time the current file is changed while the tree is open.
            hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
            -- in whatever position is specified in window.position
            -- "open_current",  -- netrw disabled, opening a directory opens within the
            -- window like netrw would, regardless of window.position
            -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
            use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
            -- instead of relying on nvim autocmd events.
        },
        buffers = {
            show_unloaded = true,
            window = {
                mappings = {
                    ["bd"] = "buffer_delete",
                },
            },
        },
    }

    vim.keymap.set("n", "<leader>b", "<cmd>Neotree toggle show buffers right<cr>")
    vim.keymap.set("n", "<leader>a", "<cmd>Neotree reveal left<cr>")
    vim.keymap.set("n", "<C-n>", "<cmd>Neotree toggle left<cr>")
end

return M
