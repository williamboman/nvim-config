local telescope = require "telescope"
local builtin = require "telescope.builtin"

local M = {}

local layout_config = {
    horizontal = {
        preview_width = 0.4,
    },
    vertical = {
        preview_cutoff = 43, -- height of 13" monitor, scentifically measured
        preview_height = 0.4,
    },
}

M.find = function()
    builtin.find_files {
        layout_config = layout_config,
        hidden = true,
    }
end

M.git_files = function()
    builtin.git_files { layout_config = layout_config }
end

M.file_browser = function()
    builtin.file_browser()
end

M.grep = function(opts)
    opts = opts or {}
    local search = vim.fn.input "Grep >"
    local cwd = opts.use_buffer_cwd and vim.fn.expand "%:h" or nil
    if cwd == "" then
        -- we expanded to nothing - default to cwd
        cwd = vim.loop.cwd()
    end
    if search ~= "" then
        builtin.grep_string {
            cwd = cwd,
            only_sort_text = true,
            search = search,
            use_regex = true,
            disable_coordinates = true,
            layout_strategy = "vertical",
            layout_config = {
                prompt_position = "top",
                mirror = true,
                preview_cutoff = 0,
                preview_height = 0.2,
            },
        }
    else
        builtin.live_grep {
            cwd = cwd,
            layout_strategy = "vertical",
            layout_config = {
                prompt_position = "top",
                mirror = true,
                preview_cutoff = 0,
                preview_height = 0.2,
            },
        }
    end
end

M.oldfiles = function()
    builtin.oldfiles { layout_config = layout_config }
end

M.current_buffer_fuzzy_find = function()
    builtin.current_buffer_fuzzy_find {
        layout_strategy = "vertical",
        preview_height = 0.4,
    }
end

M.project = function()
    telescope.extensions.project.project {
        display_type = "full",
    }
end

return M
