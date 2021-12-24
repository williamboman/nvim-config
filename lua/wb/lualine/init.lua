local M = {}

function M.setup()
    local gps = require "nvim-gps"

    local diff = {
        "diff",
        diff_color = {
            added = "LualineGitAdd",
            modified = "LualineGitChange",
            removed = "LualineGitDelete",
        },
    }
    local FilenamePath = {
        filename_only = 0,
        relative_path = 1,
        absolute_path = 2,
    }

    local function filename(path)
        return {
            "filename",
            path = path,
        }
    end

    local function attached_clients()
        return "(" .. vim.tbl_count(vim.lsp.buf_get_clients(0)) .. ")"
    end

    require("lualine").setup {
        sections = {
            lualine_b = { "branch", diff },
            lualine_c = {
                filename(FilenamePath.relative_path),
                { gps.get_location, cond = gps.is_available },
            },
            lualine_x = {
                "lsp_progress",
                { "diagnostics", sources = { "nvim_diagnostic" } },
                "encoding",
                { "filetype", separator = { right = "" }, right_padding = 0 },
                { attached_clients, separator = { left = "" }, left_padding = 0 },
            },
        },
        inactive_sections = {
            lualine_c = { filename(FilenamePath.absolute_path) },
        },
        extensions = { "nvim-tree", "quickfix", "toggleterm", "fugitive" },
    }
end

return M
