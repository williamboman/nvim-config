local M = {}

function M.setup()
    local gps = require "nvim-gps"

    local function attached_clients()
        return "(" .. vim.tbl_count(vim.lsp.buf_get_clients(0)) .. ")"
    end

    local function cwd()
        return vim.fn.fnamemodify(vim.loop.cwd(), ":~")
    end

    require("lualine").setup {
        options = {
            disabled_filetypes = { "neo-tree" },
        },
        sections = {
            lualine_b = { "branch", "diff", cwd },
            lualine_c = {
                { gps.get_location, cond = gps.is_available },
            },
            lualine_x = {
                { "diagnostics", sources = { "nvim_diagnostic" } },
                "filesize",
                "encoding",
                { "filetype", separator = { right = "" }, right_padding = 0 },
                { attached_clients, separator = { left = "" }, left_padding = 0 },
            },
        },
        inactive_sections = {},
        extensions = { "quickfix", "toggleterm", "fugitive" },
    }
end

return M
