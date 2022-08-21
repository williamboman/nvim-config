local ok, kanagawa = pcall(require, "kanagawa")

if not ok then
    return
end

local colors = require("kanagawa.colors").setup()

kanagawa.setup {
    overrides = {
        DressingInputFloatBorder = { fg = colors.sumiInk0, bg = colors.sumiInk0 },
        DressingInputNormalFloat = { bg = colors.sumiInk0 },
        FloatTitle = { fg = colors.sumiInk0, bg = colors.oniViolet, bold = true },
        Headline = { bg = colors.winterBlue },
        IndentBlanklineChar = { fg = colors.sumiInk2 },
        IndentBlanklineContextStart = { bold = true, underline = false },
        LualineGitAdd = { link = "GitSignsAdd" },
        LualineGitChange = { link = "GitSignsAdd" },
        LualineGitDelete = { link = "GitSignsDelete" },
        NeoTreeGitUntracked = { link = "NeoTreeGitModified" },
        NeoTreeNormal = { bg = colors.sumiInk0 },
        NeoTreeNormalNC = { bg = colors.sumiInk0 },
        NeoTreeWinSeparator = { fg = colors.sumiInk1, bg = colors.sumiInk1 },
        TabLine = { fg = colors.katanaGray, bg = colors.sumiInk3 },
        TabLineFill = { bg = colors.sumiInk1 },
        TabLineSel = { fg = colors.oniViolet, bg = colors.sumiInk2, bold = true },
        TabLineSelSpacing = { bg = colors.sumiInk1, fg = colors.sumiInk2 },
        TabLineSpacing = { bg = colors.sumiInk1, fg = colors.sumiInk3 },
        TelescopeBorder = { fg = colors.sumiInk0, bg = colors.sumiInk0 },
        TelescopeMatching = { underline = true, fg = colors.springBlue, sp = colors.springBlue },
        TelescopeNormal = { bg = colors.sumiInk0 },
        TelescopePreviewTitle = { fg = colors.sumiInk0, bg = colors.springBlue },
        TelescopePromptBorder = { fg = colors.sumiInk2, bg = colors.sumiInk2 },
        TelescopePromptNormal = { fg = colors.fujiWhite, bg = colors.sumiInk2 },
        TelescopePromptPrefix = { fg = colors.oniViolet, bg = colors.sumiInk2 },
        TelescopePromptTitle = { fg = colors.sumiInk0, bg = colors.oniViolet },
        TelescopeResultsTitle = { fg = colors.sumiInk0, bg = colors.sumiInk0 },
        TelescopeTitle = { bold = true, fg = colors.oldWhite },
        WinBarActive = { fg = colors.sumiInk2, bg = colors.sumiInk1 },
        WinBarActiveMuted = { fg = colors.katanaGray },
        WinBarInactive = { fg = colors.sumiInk2, bg = colors.sumiInk1 },
        WinBarInactiveMuted = { fg = colors.winterYellow },
        WinBarTextActive = { fg = colors.springBlue, bg = colors.sumiInk2, bold = true },
        WinBarTextInactive = { fg = colors.fujiGray, bg = colors.sumiInk2 },
        WinSeparator = { fg = colors.sumiInk3 },
    },
}
