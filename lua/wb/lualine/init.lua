local M = {}

function M.setup()
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

    local auto_theme = require "lualine.themes.auto"

    auto_theme.visual.a.bg = "#B48EAD"
    auto_theme.visual.b.fg = "#B48EAD"

    auto_theme.command.a.bg = "#88C0D0"
    auto_theme.command.b.fg = "#88C0D0"

    require("lualine").setup {
        options = { theme = auto_theme },
        sections = {
            lualine_b = { "branch", diff },
            lualine_c = {
                filename(FilenamePath.relative_path),
            },
            lualine_x = {
                "lsp_progress",
                { "diagnostics", sources = { "nvim" } },
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
