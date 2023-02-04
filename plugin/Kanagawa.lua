local deps_ok, kanagawa, tint = pcall(function()
    return require "kanagawa", require "tint.transforms"
end)
if not deps_ok then
    return
end

KANAGAWA_COLORS = require("kanagawa.colors").setup()

kanagawa.setup {
    overrides = {
        DiagnosticLineError = { bg = "#2f2424" },
        DiagnosticLineWarn = { bg = "#2f2b24" },
        DiagnosticUnderlineError = { sp = tint.transform_color({}, "#2f2424", { tint.saturate(3), tint.tint(40) }) },
        DiagnosticUnderlineHint = { sp = tint.transform_color({}, "#24282f", { tint.saturate(3), tint.tint(40) }) },
        DiagnosticUnderlineInfo = { sp = tint.transform_color({}, "#242c2f", { tint.saturate(3), tint.tint(40) }) },
        DiagnosticUnderlineWarn = { sp = tint.transform_color({}, "#2f2b24", { tint.saturate(3), tint.tint(40) }) },
        DressingInputFloatBorder = { fg = KANAGAWA_COLORS.sumiInk0, bg = KANAGAWA_COLORS.sumiInk0 },
        DressingInputNormalFloat = { bg = KANAGAWA_COLORS.sumiInk0 },
        FloatTitle = { fg = KANAGAWA_COLORS.sumiInk0, bg = KANAGAWA_COLORS.oniViolet, bold = true },
        GlancePreviewMatch = { undercurl = true },
        GlanceWinBarFilePath = { italic = true, bg = KANAGAWA_COLORS.waveBlue2, fg = KANAGAWA_COLORS.fujiWhite },
        GlanceWinBarFilename = { bold = true, bg = KANAGAWA_COLORS.waveBlue2, fg = KANAGAWA_COLORS.fujiWhite },
        GlanceWinBarTitle = { bold = true, bg = KANAGAWA_COLORS.waveBlue2, fg = KANAGAWA_COLORS.fujiWhite },
        Headline = { bg = KANAGAWA_COLORS.winterBlue },
        IndentBlanklineChar = { fg = KANAGAWA_COLORS.sumiInk2 },
        IndentBlanklineContextStart = { bold = true, underline = false },
        LspInlayHint = { fg = KANAGAWA_COLORS.fujiGray, bg = "#272737", italic = true },
        LspInlayHintBorder = { fg = "#272737" },
        LualineGitAdd = { link = "GitSignsAdd" },
        LualineGitChange = { link = "GitSignsAdd" },
        LualineGitDelete = { link = "GitSignsDelete" },
        NeoTreeGitUntracked = { link = "NeoTreeGitModified" },
        NeoTreeNormal = { bg = KANAGAWA_COLORS.sumiInk0 },
        NeoTreeNormalNC = { bg = KANAGAWA_COLORS.sumiInk0 },
        NeoTreeWinSeparator = { fg = KANAGAWA_COLORS.sumiInk1, bg = KANAGAWA_COLORS.sumiInk1 },
        NeotestAdapterName = { fg = KANAGAWA_COLORS.autumnRed },
        NeotestDir = { link = "Directory" },
        NeotestExpandMarker = { fg = KANAGAWA_COLORS.sumiInk2 },
        NeotestFailed = { fg = KANAGAWA_COLORS.samuraiRed },
        NeotestFile = { link = "Directory" },
        NeotestFocused = { underline = false, bold = true },
        NeotestIndent = { fg = KANAGAWA_COLORS.sumiInk2 },
        NeotestMarked = { fg = KANAGAWA_COLORS.springBlue },
        NeotestNamespace = { bold = true, fg = KANAGAWA_COLORS.dragonBlue },
        NeotestPassed = { fg = KANAGAWA_COLORS.springGreen },
        NeotestRunning = { fg = KANAGAWA_COLORS.autumnYellow },
        NeotestSkipped = { fg = KANAGAWA_COLORS.springViolet1 },
        NeotestTarget = { fg = KANAGAWA_COLORS.roninYellow },
        NeotestWinSelect = { fg = KANAGAWA_COLORS.sumiInk0, bg = KANAGAWA_COLORS.waveBlue2 },
        NotifierContentError = { fg = KANAGAWA_COLORS.autumnRed },
        NotifierContentWarn = { fg = KANAGAWA_COLORS.autumnYellow },
        NotifierTitle = { link = "Comment" },
        TabLine = { fg = KANAGAWA_COLORS.katanaGray, bg = KANAGAWA_COLORS.sumiInk3 },
        TabLineFill = { bg = KANAGAWA_COLORS.sumiInk1 },
        TabLineSel = { fg = KANAGAWA_COLORS.oniViolet, bg = KANAGAWA_COLORS.sumiInk2, bold = true },
        TabLineSelSpacing = { bg = KANAGAWA_COLORS.sumiInk1, fg = KANAGAWA_COLORS.sumiInk2 },
        TabLineSpacing = { bg = KANAGAWA_COLORS.sumiInk1, fg = KANAGAWA_COLORS.sumiInk3 },
        TelescopeBorder = { fg = KANAGAWA_COLORS.sumiInk0, bg = KANAGAWA_COLORS.sumiInk0 },
        TelescopeMatching = { underline = true, fg = KANAGAWA_COLORS.springBlue, sp = KANAGAWA_COLORS.springBlue },
        TelescopeNormal = { bg = KANAGAWA_COLORS.sumiInk0 },
        TelescopePreviewTitle = { fg = KANAGAWA_COLORS.sumiInk0, bg = KANAGAWA_COLORS.springBlue },
        TelescopePromptBorder = { fg = KANAGAWA_COLORS.sumiInk2, bg = KANAGAWA_COLORS.sumiInk2 },
        TelescopePromptNormal = { fg = KANAGAWA_COLORS.fujiWhite, bg = KANAGAWA_COLORS.sumiInk2 },
        TelescopePromptPrefix = { fg = KANAGAWA_COLORS.oniViolet, bg = KANAGAWA_COLORS.sumiInk2 },
        TelescopePromptTitle = { fg = KANAGAWA_COLORS.sumiInk0, bg = KANAGAWA_COLORS.oniViolet },
        TelescopeResultsTitle = { fg = KANAGAWA_COLORS.sumiInk0, bg = KANAGAWA_COLORS.sumiInk0 },
        TelescopeTitle = { bold = true, fg = KANAGAWA_COLORS.oldWhite },
        WinBarActive = { fg = KANAGAWA_COLORS.sumiInk2, bg = KANAGAWA_COLORS.sumiInk1 },
        WinBarActiveMuted = { fg = KANAGAWA_COLORS.katanaGray },
        WinBarInactive = { fg = KANAGAWA_COLORS.sumiInk2, bg = KANAGAWA_COLORS.sumiInk1 },
        WinBarInactiveMuted = { fg = KANAGAWA_COLORS.winterYellow },
        WinBarTextActive = { fg = KANAGAWA_COLORS.springBlue, bg = KANAGAWA_COLORS.sumiInk2, bold = true },
        WinBarTextInactive = { fg = KANAGAWA_COLORS.fujiGray, bg = KANAGAWA_COLORS.sumiInk2 },
        WinSeparator = { fg = KANAGAWA_COLORS.sumiInk3 },
    },
}

vim.cmd.colorscheme { "kanagawa" }
