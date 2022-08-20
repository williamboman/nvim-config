local keymap = vim.keymap.set

local function goto_prev_error()
    vim.diagnostic.goto_prev { severity = "Error" }
end

local function goto_next_error()
    vim.diagnostic.goto_next { severity = "Error" }
end

for _, mode in pairs { "n", "v" } do
    keymap(mode, "[e", goto_prev_error)
    keymap(mode, "]e", goto_next_error)
    keymap(mode, "[E", vim.diagnostic.goto_prev)
    keymap(mode, "]E", vim.diagnostic.goto_next)
end

keymap("n", "].", vim.diagnostic.open_float)

keymap("n", "<space>d", function()
    require("telescope.builtin").diagnostics { bufnr = 0 }
end)

keymap("n", "<C-w>z", "<cmd>MaximizerToggle!<CR>")

-- je ne pais parlaiz francais
keymap("n", "à", "`a")
keymap("n", "è", "`e")
keymap("n", "ì", "`i")
keymap("n", "ò", "`o")
keymap("n", "ù", "`u")
keymap("n", "á", "`a")
keymap("n", "é", "`e")
keymap("n", "í", "`i")
keymap("n", "ó", "`o")
keymap("n", "ú", "`u")
keymap("n", "ý", "`y")
keymap("n", "À", "`A")
keymap("n", "È", "`E")
keymap("n", "Ì", "`I")
keymap("n", "Ò", "`O")
keymap("n", "Ù", "`U")
keymap("n", "Á", "`A")
keymap("n", "É", "`E")
keymap("n", "Í", "`I")
keymap("n", "Ó", "`O")
keymap("n", "Ú", "`U")
keymap("n", "Ý", "`Y")

keymap("n", "´b", "`b")
keymap("n", "´c", "`c")
keymap("n", "´d", "`d")
keymap("n", "´f", "`f")
keymap("n", "´g", "`g")
keymap("n", "´h", "`h")
keymap("n", "´j", "`j")
keymap("n", "´k", "`k")
keymap("n", "´l", "`l")
keymap("n", "´m", "`m")
keymap("n", "´n", "`n")
keymap("n", "´p", "`p")
keymap("n", "´q", "`q")
keymap("n", "´r", "`r")
keymap("n", "´s", "`s")
keymap("n", "´t", "`t")
keymap("n", "´v", "`v")
keymap("n", "´w", "`w")
keymap("n", "´x", "`x")
keymap("n", "´z", "`z")
keymap("n", "´B", "`B")
keymap("n", "´C", "`C")
keymap("n", "´D", "`D")
keymap("n", "´F", "`F")
keymap("n", "´G", "`G")
keymap("n", "´H", "`H")
keymap("n", "´J", "`J")
keymap("n", "´K", "`K")
keymap("n", "´L", "`L")
keymap("n", "´M", "`M")
keymap("n", "´N", "`N")
keymap("n", "´P", "`P")
keymap("n", "´Q", "`Q")
keymap("n", "´R", "`R")
keymap("n", "´S", "`S")
keymap("n", "´T", "`T")
keymap("n", "´V", "`V")
keymap("n", "´W", "`W")
keymap("n", "´X", "`X")
keymap("n", "´Z", "`Z")
