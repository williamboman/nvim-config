vim.cmd.packadd "kanagawa.nvim"

local function clamp(component)
    return math.min(math.max(component, 0), 255)
end

local function rgb_to_hex(r, g, b)
    return string.format("#%06x", clamp(r) * 0x10000 + clamp(g) * 0x100 + clamp(b))
end

local function hex_to_rgb(hex)
    if string.find(hex, "^#") then
        hex = string.sub(hex, 2)
    end

    local base16 = tonumber(hex, 16)
    return math.floor(base16 / 0x10000), (math.floor(base16 / 0x100) % 0x100), (base16 % 0x100)
end

local function transform_color(hex, xforms)
    local r, g, b = hex_to_rgb(hex)

    for _, x in ipairs(xforms) do
        r, g, b = x(r, g, b)
    end

    return rgb_to_hex(r, g, b)
end

local function tint(amt)
    return function(r, g, b)
        return r + amt, g + amt, b + amt
    end
end

local function saturate(amt)
    return function(r, g, b)
        if amt ~= 1 then
            local rec601_luma = 0.299 * r + 0.587 * g + 0.114 * b

            r = math.floor(r * amt + rec601_luma * (1 - amt))
            g = math.floor(g * amt + rec601_luma * (1 - amt))
            b = math.floor(b * amt + rec601_luma * (1 - amt))
        end

        return r, g, b
    end
end

require("kanagawa").setup {
    overrides = function(colors)
        local palette = colors.palette
        return {
            DiagnosticUnderlineError = { sp = transform_color("#2f2424", { saturate(3), tint(40) }) },
            DiagnosticUnnecessary = {},
            DiagnosticUnderlineHint = { sp = transform_color("#24282f", { saturate(3), tint(40) }) },
            DiagnosticUnderlineInfo = { sp = transform_color("#242c2f", { saturate(3), tint(40) }) },
            DiagnosticUnderlineWarn = { sp = transform_color("#2f2b24", { saturate(3), tint(40) }) },
            FloatTitle = { fg = palette.sumiInk0, bg = palette.oniViolet, bold = true },
            GlancePreviewMatch = { undercurl = true },
            GlanceWinBarFilePath = { italic = true, bg = palette.waveBlue2, fg = palette.fujiWhite },
            GlanceWinBarFilename = { bold = true, bg = palette.waveBlue2, fg = palette.fujiWhite },
            GlanceWinBarTitle = { bold = true, bg = palette.waveBlue2, fg = palette.fujiWhite },
            IndentBlanklineChar = { fg = palette.sumiInk2 },
            IndentBlanklineContextStart = { bold = true, underline = false },
            LspInlayHint = { fg = palette.fujiGray, bg = "#272737", italic = true },
            LspInlayHintBorder = { fg = "#272737" },
            MoreMsg = { bg = "none" },
            TabLine = { fg = palette.katanaGray, bg = palette.sumiInk3 },
            TabLineFill = { bg = palette.sumiInk1 },
            TabLineSel = { fg = palette.oniViolet, bg = palette.sumiInk2, bold = true },
            TelescopeBorder = { fg = palette.sumiInk0, bg = palette.sumiInk0 },
            TelescopeMatching = { underline = true, fg = palette.springBlue, sp = palette.springBlue },
            TelescopeNormal = { bg = palette.sumiInk0 },
            TelescopePreviewTitle = { fg = palette.sumiInk0, bg = palette.springBlue },
            TelescopePromptBorder = { fg = palette.sumiInk2, bg = palette.sumiInk2 },
            TelescopePromptNormal = { fg = palette.fujiWhite, bg = palette.sumiInk2 },
            TelescopePromptPrefix = { fg = palette.oniViolet, bg = palette.sumiInk2 },
            TelescopePromptTitle = { fg = palette.sumiInk0, bg = palette.oniViolet },
            TelescopeResultsTitle = { fg = palette.sumiInk0, bg = palette.sumiInk0 },
            TelescopeTitle = { bold = true, fg = palette.oldWhite },
            StatusLine = { bg = palette.sumiInk2 },
            StatusLineTerm = { link = "StatusLine" },
            StatusLineTermNC = { link = "StatusLineNC" },
            WinBar = { link = "StatusLine" },
            WinBarNC = { link = "StatusLineNC" },
            TermNormal = { bg = palette.sumiInk0 }
        }
    end
}

vim.cmd.colorscheme "kanagawa"
