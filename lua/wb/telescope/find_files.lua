local builtin = require("telescope.builtin")

local M = {}

M.find = function()
    builtin.find_files(
        {
            find_command = {
                "rg",
                "--hidden",
                "--no-ignore",
                "--follow",
                "--files",
                "--smart-case"
            }
        }
    )
end

M.git_files = function()
    builtin.git_files()
end

M.grep = function()
    local search = vim.fn.input("Grep >")
    if search then
        builtin.grep_string({only_sort_text = true, search = search})
    else
        builtin.live_grep()
    end
end

M.oldfiles = function()
    builtin.oldfiles()
end

M.current_buffer_fuzzy_find = function()
    builtin.current_buffer_fuzzy_find()
end

return M
