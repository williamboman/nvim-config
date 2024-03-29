local ok, telescope = pcall(require, "telescope")
if not ok then
    return
end
local builtin = require "telescope.builtin"
local actions = require "telescope.actions"
local layout_actions = require "telescope.actions.layout"
local files = require "wb.telescope.find_files"
local git = require "wb.telescope.git"

telescope.setup {
    defaults = {
        file_sorter = require("telescope.sorters").get_fzy_sorter,
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        prompt_prefix = "  ",
        selection_caret = "  ",
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
        winblend = 5,
        set_env = { ["COLORTERM"] = "truecolor" },
        border = {},
        borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
        mappings = {
            i = {
                ["<C-w>"] = function()
                    vim.api.nvim_input "<c-s-w>"
                end,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-p>"] = actions.cycle_history_prev,
                ["<C-n>"] = actions.cycle_history_next,
                ["<C-l>"] = layout_actions.toggle_preview,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                ["<Esc>"] = actions.close,
                ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
                ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
            },
        },
    },
    extensions = {
        project = {
            hidden_files = false,
        },
        fzf = is_win and {} or {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
    },
}

---@param lhs string
---@param rhs string|fun()
local function telescope_map(lhs, rhs)
    for _, keymap in pairs { "<C-p>" .. lhs, "<C-p>" .. "<C-" .. lhs .. ">" } do
        vim.keymap.set("n", keymap, rhs)
    end
end

telescope_map("r", "<cmd>Telescope resume<CR>")

telescope_map("f", files.find)
telescope_map(".f", function()
    files.find { use_buffer_cwd = true }
end)
telescope_map("p", files.git_files)
vim.keymap.set("n", "<space>p", files.git_files)
telescope_map(".p", function()
    files.git_files { use_buffer_cwd = true }
end)
telescope_map("a", files.file_browser)
telescope_map("l", files.current_buffer_fuzzy_find)
telescope_map("o", files.project)
telescope_map("q", files.grep)
telescope_map('"', builtin.registers)
telescope_map(".q", function()
    files.grep { use_buffer_cwd = true }
end)
telescope_map("h", files.oldfiles)
telescope_map("b", files.buffers)

telescope_map("s", git.status)
telescope_map("S", git.stash)

local is_win = vim.fn.has "win32" == 1
if not is_win then
    require("telescope").load_extension "fzf"
end

local original_edit = require("telescope.actions.set").edit
require("telescope.actions.set").edit = function(...)
    original_edit(...)
    vim.cmd.stopinsert()
end

return M
