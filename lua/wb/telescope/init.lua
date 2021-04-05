local actions = require('telescope.actions')

local M = {}

local function keymaps()
    vim.api.nvim_set_keymap('n', '<C-p>f', "<cmd>lua require'wb.telescope.find_files'.find()<CR>", {noremap=false})
    for _, map in pairs({ "<C-p>p", "<C-p><C-p>" }) do
        vim.api.nvim_set_keymap('n', map, "<cmd>lua require'wb.telescope.find_files'.git_files()<CR>", {noremap=false})
    end

    for _, map in pairs({ "<C-p>s", "<C-p><C-s>" }) do
        vim.api.nvim_set_keymap('n', map, "<cmd>lua require'wb.telescope.git'.modified_files()<CR>", {noremap=false})
    end

    vim.api.nvim_set_keymap('n', '<C-p>q', "<cmd>lua require'wb.telescope.find_files'.live_grep()<CR>", {noremap=false})
    vim.api.nvim_set_keymap('n', '<C-p>h', "<cmd>lua require'wb.telescope.find_files'.oldfiles()<CR>", {noremap=false})

    vim.api.nvim_set_keymap('n', '<C-p>bc', "<cmd> lua require'wb.telescope.git'.bcommits()<CR>", {noremap=false})
    vim.api.nvim_set_keymap('n', '<C-p>c', "<cmd> lua require'wb.telescope.git'.commits()<CR>", {noremap=false})
end

M.setup = function ()
    -- require'telescope'.load_extension'fzy_native'

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
        -- extensions = {
        --     fzy_native = {
        --         override_generic_sorter = false,
        --         override_file_sorter = true,
        --     }
        -- }
    }

    keymaps()
end

return M
