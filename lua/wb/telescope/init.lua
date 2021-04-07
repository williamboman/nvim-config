local actions = require('telescope.actions')

local M = {}

local function map_uwu(key, cmd)
    for _, keymap in pairs({"<C-p>"..key, "<C-p>".."<C-"..key..">"}) do
        vim.api.nvim_set_keymap('n', keymap, cmd, {noremap=true})
    end
end

local function keymaps()
    map_uwu("f", "<cmd>lua require'wb.telescope.find_files'.find()<CR>")
    map_uwu("p", "<cmd>lua require'wb.telescope.find_files'.git_files()<CR>")
    map_uwu("l", "<cmd>lua require'wb.telescope.find_files'.current_buffer_fuzzy_find()<CR>")
    map_uwu("q", "<cmd>lua require'wb.telescope.find_files'.live_grep()<CR>")
    map_uwu("h", "<cmd>lua require'wb.telescope.find_files'.oldfiles()<CR>")

    map_uwu("s", "<cmd>lua require'wb.telescope.git'.modified_files()<CR>")
    map_uwu("b", "<cmd>lua require'wb.telescope.git'.bcommits()<CR>")
    map_uwu("c", "<cmd>lua require'wb.telescope.git'.commits()<CR>")
end

M.setup = function ()
    require'telescope'.load_extension'fzy_native'

    require('telescope').setup {
        defaults = {
            vimgrep_arguments = {
                'rg',
                '--hidden',
                '--color=never',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
                '--smart-case',
            },
            file_sorter = require'telescope.sorters'.get_fzy_sorter,
            prompt_prefix = ' ❯ ',
            selection_caret = '❯ ',

            file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
            grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
            qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

            selection_strategy = "reset",
            sorting_strategy = "descending",
            scroll_strategy = nil,
            color_devicons = true,

            layout_strategy = 'horizontal',

            mappings = {
                i = {
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                    ["<Esc>"] = actions.close,
                    ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
                    ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
                },
                n = {
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                }
            }
        },
        extensions = {
            fzy_native = {
                override_generic_sorter = true,
                override_file_sorter = true,
            }
        }
    }

    keymaps()
end

return M
