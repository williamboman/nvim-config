local ok, kanagawa = pcall(require, "kanagawa")

if not ok then
    return
end

kanagawa.setup {
    overrides = {
        WinSeparator = { fg = "#363646" },
        NeoTreeWinSeparator = { fg = "#16161D", bg = "#16161D" },
        WinBarActive = { fg = "#2A2A37", bg = "#1F1F28" },
        WinBarActiveMuted = { fg = "#666666" },
        WinBarInactiveMuted = { fg = "#444444" },
        WinBarTextActive = { fg = "#7FB4CA", bg = "#2A2A37", style = "bold" },
        WinBarInactive = { fg = "#2A2A37", bg = "#1F1F28" },
        WinBarTextInactive = { fg = "#7a7a7b", bg = "#2A2A37" },
        Comment = { fg = "#888181" },
        FloatTitle = { fg = "#14141A", bg = "#957FB8", style = "bold" },
        DressingInputNormalFloat = { bg = "#14141A" },
        DressingInputFloatBorder = { fg = "#14141A", bg = "#14141A" },
        NeoTreeGitUntracked = { link = "NeoTreeGitModified" },
        IndentBlanklineChar = { fg = "#2F2F40" },
        IndentBlanklineContextStart = { style = "bold" },
        LualineGitAdd = { link = "GitSignsAdd" },
        LualineGitChange = { link = "GitSignsAdd" },
        LualineGitDelete = { link = "GitSignsDelete" },
        NeoTreeNormal = { bg = "#14141A" },
        NeoTreeNormalNC = { bg = "#14141A" },
        TabLine = { fg = "#7a7a7b", bg = "#363646" },
        TabLineFill = { bg = "#1F1F28" },
        TabLineSel = { fg = "#957FB8", bg = "#2A2A37", style = "bold" },
        TabLineSelSpacing = { fg = "#1F1F28", bg = "#2A2A37", style = "inverse" },
        TabLineSpacing = { fg = "#1F1F28", bg = "#363646", style = "inverse" },
        TelescopeBorder = { fg = "#1a1a22", bg = "#1a1a22" },
        TelescopeMatching = { style = "underline", fg = "#7FB4CA", guisp = "#7FB4CA" },
        TelescopeNormal = { bg = "#1a1a22" },
        TelescopePreviewTitle = { fg = "#1a1a22", bg = "#7FB4CA" },
        TelescopePromptBorder = { fg = "#2A2A37", bg = "#2A2A37" },
        TelescopePromptNormal = { fg = "#DCD7BA", bg = "#2A2A37" },
        TelescopePromptPrefix = { fg = "#957FB8", bg = "#2A2A37" },
        TelescopePromptTitle = { fg = "#1a1a22", bg = "#957FB8" },
        TelescopeResultsTitle = { fg = "#1a1a22", bg = "#1a1a22" },
        TelescopeTitle = { style = "bold", fg = "#C8C093" },
        Visual = { bg = "#4C566A" },
    },
}
