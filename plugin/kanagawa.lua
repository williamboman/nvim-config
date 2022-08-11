local ok, kanagawa = pcall(require, "kanagawa")

if not ok then
    return
end

kanagawa.setup {
    overrides = {
        Comment = { fg = "#888181" },
        DressingInputFloatBorder = { fg = "#14141A", bg = "#14141A" },
        DressingInputNormalFloat = { bg = "#14141A" },
        FloatTitle = { fg = "#14141A", bg = "#957FB8", bold = true },
        IndentBlanklineChar = { fg = "#2F2F40" },
        IndentBlanklineContextStart = { bold = true, underline = false },
        LualineGitAdd = { link = "GitSignsAdd" },
        LualineGitChange = { link = "GitSignsAdd" },
        LualineGitDelete = { link = "GitSignsDelete" },
        NeoTreeGitUntracked = { link = "NeoTreeGitModified" },
        NeoTreeNormal = { bg = "#14141A" },
        NeoTreeNormalNC = { bg = "#14141A" },
        NeoTreeWinSeparator = { fg = "#16161D", bg = "#16161D" },
        TabLine = { fg = "#7a7a7b", bg = "#363646" },
        TabLineFill = { bg = "#1F1F28" },
        TabLineSel = { fg = "#957FB8", bg = "#2A2A37", bold = true },
        TabLineSelSpacing = { bg = "#1F1F28", fg = "#2A2A37" },
        TabLineSpacing = { bg = "#1F1F28", fg = "#363646" },
        TelescopeBorder = { fg = "#1a1a22", bg = "#1a1a22" },
        TelescopeMatching = { underline = true, fg = "#7FB4CA", sp = "#7FB4CA" },
        TelescopeNormal = { bg = "#1a1a22" },
        TelescopePreviewTitle = { fg = "#1a1a22", bg = "#7FB4CA" },
        TelescopePromptBorder = { fg = "#2A2A37", bg = "#2A2A37" },
        TelescopePromptNormal = { fg = "#DCD7BA", bg = "#2A2A37" },
        TelescopePromptPrefix = { fg = "#957FB8", bg = "#2A2A37" },
        TelescopePromptTitle = { fg = "#1a1a22", bg = "#957FB8" },
        TelescopeResultsTitle = { fg = "#1a1a22", bg = "#1a1a22" },
        TelescopeTitle = { bold = true, fg = "#C8C093" },
        Visual = { bg = "#4C566A" },
        WinBarActive = { fg = "#2A2A37", bg = "#1F1F28" },
        WinBarActiveMuted = { fg = "#666666" },
        WinBarInactive = { fg = "#2A2A37", bg = "#1F1F28" },
        WinBarInactiveMuted = { fg = "#444444" },
        WinBarTextActive = { fg = "#7FB4CA", bg = "#2A2A37", bold = true },
        WinBarTextInactive = { fg = "#7a7a7b", bg = "#2A2A37" },
        WinSeparator = { fg = "#363646" },
    },
}
