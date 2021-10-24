local M = {}

local custom_condition = {
    buffer_not_empty = function()
        if vim.fn.empty(vim.fn.expand "%:t") ~= 1 then
            return true
        end
        return false
    end,
    wide_window_condition = function()
        return vim.fn.winwidth "%" >= 160 -- 160 is a somewhat random number. it felt nice.
    end,
}

M.setup = function()
    local gl = require "galaxyline"
    local colors = {
        bg = "#1B1F28",
        fg = "#E5E9F0",
        yellow = "#EBCB8B",
        dark_yellow = "#D7BA7D",
        cyan = "#8FBCBB",
        green = "#A3BE8C",
        light_green = "#B5CEA8",
        string_orange = "#D08770",
        orange = "#FF8800",
        purple = "#B48EAD",
        magenta = "#D16D9E",
        grey = "#858585",
        blue = "#5E81AC",
        vivid_blue = "#81A1C1",
        light_blue = "#88C0D0",
        red = "#BF616A",
        error_red = "#F44747",
        info_yellow = "#FFCC66",
    }

    local condition = require "galaxyline.condition"
    local gls = gl.section

    -- filetypes in which galaxyline should display short version
    gl.short_line_list = { "NvimTree", "vista", "dbui", "packer" }

    gls.left[1] = {
        ViMode = {
            provider = function()
                -- refer to `:help mode()`
                local aliases = {
                    n = "NORMAL",
                    no = "NORMAL",
                    nov = "NORMAL",
                    niI = "NORMAL",
                    niR = "NORMAL",
                    niV = "NORMAL",
                    v = "VISUAL",
                    V = "V-LINE",
                    s = "SELECT",
                    S = "S-LINE",
                    i = "INSERT",
                    ic = "INSERT",
                    ix = "INSERT",
                    R = "REPLACE",
                    Rc = "REPLACE",
                    Rv = "R-VIRTUAL",
                    Rx = "REPLACE",
                    c = "COMMAND-LINE",
                    cv = "EX",
                    ce = "EX",
                    r = "R-PROMPT",
                    rm = "--MORE",
                    ["r?"] = ":CONFIRM",
                    ["!"] = "SHELL",
                    t = "TERMINAL",
                }

                local byte_aliases = {
                    [22] = "V-BLOCK", -- <C-v>
                }

                local mode_colors = {
                    NORMAL = colors.blue,
                    INSERT = colors.green,
                    VISUAL = colors.purple,
                    ["V-LINE"] = colors.purple,
                    ["V-BLOCK"] = colors.purple,
                    SELECT = colors.orange,
                    ["S-LINE"] = colors.orange,
                    REPLACE = colors.red,
                    ["R-PROMPT"] = colors.red,
                    ["--MORE"] = colors.red,
                    [":CONFIRM"] = colors.red,
                    ["R-VIRTUAL"] = colors.red,
                    ["COMMAND-LINE"] = colors.magenta,
                    ["EX"] = colors.blue,
                    SHELL = colors.cyan,
                    TERMINAL = colors.cyan,
                }

                local mode_alias = aliases[vim.fn.mode()] or byte_aliases[vim.fn.mode():byte()]
                local mode_color = mode_colors[mode_alias]

                vim.api.nvim_command("hi GalaxyViMode gui=bold guifg=" .. colors.fg .. " guibg=" .. mode_color)

                if vim.o.paste and (mode_alias == "NORMAL" or mode_alias == "INSERT") then
                    mode_alias = "PASTE"
                end
                return "  " .. mode_alias .. " "
            end,
            highlight = { colors.red, colors.bg },
            separator_highlight = { "NONE", colors.bg },
            separator = " ",
        },
    }

    gls.left[2] = {
        ReadOnly = {
            provider = function()
                return "RO"
            end,
            condition = function()
                return vim.bo.readonly
            end,
            highlight = { colors.orange, colors.bg },
            separator_highlight = { "NONE", colors.bg },
            separator = " ",
        },
    }

    gls.left[3] = {
        GitIcon = {
            provider = function()
                return " "
            end,
            condition = function()
                return condition.check_git_workspace() and custom_condition.wide_window_condition()
            end,
            separator = " ",
            separator_highlight = { "NONE", colors.bg },
            highlight = { colors.orange, colors.bg },
        },
    }

    gls.left[4] = {
        GitBranch = {
            provider = "GitBranch",
            condition = function()
                return condition.check_git_workspace() and custom_condition.wide_window_condition()
            end,
            separator = " ",
            separator_highlight = { "NONE", colors.bg },
            highlight = { colors.grey, colors.bg },
        },
    }

    gls.left[5] = {
        DiffAdd = {
            provider = "DiffAdd",
            condition = condition.hide_in_width,
            icon = "  ",
            highlight = { colors.green, colors.bg },
        },
    }
    gls.left[6] = {
        DiffModified = {
            provider = "DiffModified",
            condition = condition.hide_in_width,
            icon = " 柳",
            highlight = { colors.blue, colors.bg },
        },
    }
    gls.left[7] = {
        DiffRemove = {
            provider = "DiffRemove",
            condition = condition.hide_in_width,
            icon = "  ",
            highlight = { colors.red, colors.bg },
            separator = " ",
            separator_highlight = { "NONE", colors.bg },
        },
    }

    gls.left[8] = {
        FileIcon = {
            provider = "FileIcon",
            condition = custom_condition.buffer_not_empty,
            highlight = { require("galaxyline.providers.fileinfo").get_file_icon_color, colors.bg },
            separator = " ",
            separator_highlight = { "NONE", colors.bg },
        },
    }
    gls.left[9] = {
        FileName = {
            provider = {
                function()
                    return (vim.bo.modifiable and vim.bo.modified) and " " or ""
                end,
                function()
                    local h = vim.fn.expand "%:h"
                    if h == "." then
                        return ""
                    end
                    return h .. "/"
                end,
                function()
                    return vim.fn.expand "%:t"
                end,
            },
            separator = " ",
            condition = custom_condition.buffer_not_empty,
            highlight = { colors.fg, colors.bg, "bold" },
            separator_highlight = { "NONE", colors.bg },
        },
    }

    gls.left[10] = {
        FileSize = {
            provider = "FileSize",
            highlight = { colors.grey, colors.bg },
            separator = "  ",
            separator_highlight = { "NONE", colors.bg },
        },
    }

    gls.right[1] = {
        DiagnosticError = { provider = "DiagnosticError", icon = "  ", highlight = { colors.error_red, colors.bg } },
    }
    gls.right[2] = {
        DiagnosticWarn = { provider = "DiagnosticWarn", icon = "  ", highlight = { colors.orange, colors.bg } },
    }

    gls.right[3] = {
        DiagnosticHint = { provider = "DiagnosticHint", icon = "  ", highlight = { colors.vivid_blue, colors.bg } },
    }

    gls.right[4] = {
        DiagnosticInfo = { provider = "DiagnosticInfo", icon = "  ", highlight = { colors.info_yellow, colors.bg } },
    }

    gls.right[5] = {
        LineInfo = {
            provider = "LineColumn",
            separator = " ",
            separator_highlight = { "NONE", colors.bg },
            highlight = { colors.grey, colors.bg },
        },
    }

    gls.right[6] = {
        PerCent = {
            provider = "LinePercent",
            separator = " ",
            separator_highlight = { "NONE", colors.bg },
            highlight = { colors.grey, colors.bg },
        },
    }

    gls.right[7] = {
        BufferType = {
            provider = "FileTypeName",
            condition = function()
                return custom_condition.wide_window_condition() and custom_condition.buffer_not_empty()
            end,
            separator = " ",
            separator_highlight = { "NONE", colors.bg },
            highlight = { colors.grey, colors.bg },
        },
    }

    gls.right[8] = {
        ShowLspClient = {
            provider = function()
                local clients = vim.lsp.buf_get_clients(0)
                local count = vim.tbl_count(clients)
                return "(" .. count .. ")"
            end,
            condition = function()
                local disabledFiletypes = { [" "] = true }
                if disabledFiletypes[vim.bo.filetype] then
                    return false
                end
                return true and custom_condition.wide_window_condition()
            end,
            highlight = { colors.grey, colors.bg },
        },
    }

    gls.right[9] = {
        FileEncode = {
            provider = "FileEncode",
            condition = condition.hide_in_width,
            separator = " ",
            separator_highlight = { "NONE", colors.bg },
            highlight = { colors.grey, colors.bg },
        },
    }

    local Space = {
        provider = function()
            return " "
        end,
        separator = " ",
        separator_highlight = { "NONE", colors.bg },
        highlight = { "NONE", colors.bg },
    }

    gls.right[10] = {
        Space = Space,
    }

    gls.short_line_left[1] = {
        Space = Space,
    }

    gls.short_line_left[2] = {
        RelPath = {
            provider = function()
                return vim.fn.expand "%:h" .. "/"
            end,
            condition = custom_condition.buffer_not_empty,
            highlight = { colors.grey, colors.bg },
        },
    }

    gls.short_line_left[3] = {
        SFileName = {
            provider = "SFileName",
            condition = custom_condition.buffer_not_empty,
            highlight = { colors.fg, colors.bg, "bold" },
            separator = "▲ ",
            separator_highlight = { colors.cyan, colors.bg },
        },
    }

    gls.short_line_left[4] = {
        WinNr = {
            highlight = { colors.cyan, colors.bg, "bold" },
            provider = function()
                return string.format("%d", vim.fn.winnr())
            end,
        },
    }
end

return M
