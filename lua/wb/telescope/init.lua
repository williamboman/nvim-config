local actions = require "telescope.actions"

local M = {}

local function map_uwu(key, cmd)
    for _, keymap in pairs { "<C-p>" .. key, "<C-p>" .. "<C-" .. key .. ">" } do
        vim.api.nvim_set_keymap("n", keymap, cmd, { noremap = true })
    end
end

local function keymaps()
    map_uwu("r", "<cmd>Telescope resume<CR>")

    map_uwu("f", "<cmd>lua require'wb.telescope.find_files'.find()<CR>")
    map_uwu("p", "<cmd>lua require'wb.telescope.find_files'.git_files()<CR>")
    map_uwu("a", "<cmd>lua require'wb.telescope.find_files'.file_browser()<CR>")
    map_uwu("l", "<cmd>lua require'wb.telescope.find_files'.current_buffer_fuzzy_find()<CR>")
    map_uwu("o", "<cmd>lua require'wb.telescope.find_files'.project()<CR>")
    map_uwu("q", "<cmd>lua require'wb.telescope.find_files'.grep()<CR>")
    map_uwu(".q", "<cmd>lua require'wb.telescope.find_files'.grep({use_buffer_cwd = true})<CR>")
    map_uwu("h", "<cmd>lua require'wb.telescope.find_files'.oldfiles()<CR>")

    map_uwu("s", "<cmd>lua require'wb.telescope.git'.status()<CR>")
    map_uwu("S", "<cmd>lua require'wb.telescope.git'.stash()<CR>")

    map_uwu("ws", "<cmd>lua require'wb.telescope.lsp'.workspace_symbols()<CR>")
    map_uwu("wd", "<cmd>lua require'wb.telescope.lsp'.workspace_diagnostics()<CR>")
end

M.setup = function()
    require("telescope").load_extension "fzf"

    require("telescope").setup {
        defaults = {
            file_sorter = require("telescope.sorters").get_fzy_sorter,
            generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
            file_previewer = require("telescope.previewers").vim_buffer_cat.new,
            grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
            qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
            prompt_prefix = " ❯ ",
            selection_caret = "❯ ",
            selection_strategy = "reset",
            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
                "--hidden",
                "--glob=!.git/",
            },
            sorting_strategy = "descending",
            layout_strategy = "flex",
            layout_config = {
                flex = {
                    flip_columns = 161, -- half 27" monitor, scientifically calculated
                },
                horizontal = {
                    preview_cutoff = 0,
                    preview_width = 0.6,
                },
                vertical = {
                    preview_cutoff = 0,
                    preview_height = 0.65,
                },
            },
            path_display = { truncate = 3 },
            color_devicons = true,
            winblend = 7,
            set_env = { ["COLORTERM"] = "truecolor" },
            mappings = {
                i = {
                    ["<C-w>"] = function ()
                        vim.api.nvim_input "<c-s-w>"
                    end,
                    ["<C-u>"] = function ()
                        vim.api.nvim_input "<c-s-u>"
                    end,
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-p>"] = actions.cycle_history_prev,
                    ["<C-n>"] = actions.cycle_history_next,
                    ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                    ["<Esc>"] = actions.close,
                    ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
                    ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
                },
            },
        },
        extensions = {
            project = {
                hidden_files = true,
            },
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            },
        },
    }

    keymaps()
end

return M
