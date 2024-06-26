local keymap = vim.keymap.set

local function goto_prev_error()
    vim.diagnostic.goto_prev { severity = "Error" }
end

local function goto_next_error()
    vim.diagnostic.goto_next { severity = "Error" }
end

keymap({ "n", "v" }, "[e", goto_prev_error)
keymap({ "n", "v" }, "]e", goto_next_error)
keymap({ "n", "v" }, "[d", vim.diagnostic.goto_prev)
keymap({ "n", "v" }, "]d", vim.diagnostic.goto_next)

keymap("n", "].", vim.diagnostic.open_float)

keymap("n", "<space>d", function()
    require("telescope.builtin").diagnostics { bufnr = 0 }
end)

keymap("n", "<C-w>z", "<cmd>MaximizerToggle!<CR>")

keymap("n", "<space>c", function ()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage())) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "qf" then
            vim.cmd.cclose()
            return
        end
    end
    vim.cmd.copen()
end)

keymap("n", "<space>k", function ()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage())) do
        if vim.wo[win].previewwindow then
            vim.cmd.pclose()
            return
        end
    end
end)

local remap = { remap = true }

-- Nordic QWERTY gang
keymap("n", "à", "`a", remap)
keymap("n", "è", "`e", remap)
keymap("n", "ì", "`i", remap)
keymap("n", "ò", "`o", remap)
keymap("n", "ù", "`u", remap)
keymap("n", "á", "`a", remap)
keymap("n", "é", "`e", remap)
keymap("n", "í", "`i", remap)
keymap("n", "ó", "`o", remap)
keymap("n", "ú", "`u", remap)
keymap("n", "ý", "`y", remap)
keymap("n", "À", "`A", remap)
keymap("n", "È", "`E", remap)
keymap("n", "Ì", "`I", remap)
keymap("n", "Ò", "`O", remap)
keymap("n", "Ù", "`U", remap)
keymap("n", "Á", "`A", remap)
keymap("n", "É", "`E", remap)
keymap("n", "Í", "`I", remap)
keymap("n", "Ó", "`O", remap)
keymap("n", "Ú", "`U", remap)
keymap("n", "Ý", "`Y", remap)

keymap("n", "´b", "`b", remap)
keymap("n", "´c", "`c", remap)
keymap("n", "´d", "`d", remap)
keymap("n", "´f", "`f", remap)
keymap("n", "´g", "`g", remap)
keymap("n", "´h", "`h", remap)
keymap("n", "´j", "`j", remap)
keymap("n", "´k", "`k", remap)
keymap("n", "´l", "`l", remap)
keymap("n", "´m", "`m", remap)
keymap("n", "´n", "`n", remap)
keymap("n", "´p", "`p", remap)
keymap("n", "´q", "`q", remap)
keymap("n", "´r", "`r", remap)
keymap("n", "´s", "`s", remap)
keymap("n", "´t", "`t", remap)
keymap("n", "´v", "`v", remap)
keymap("n", "´w", "`w", remap)
keymap("n", "´x", "`x", remap)
keymap("n", "´z", "`z", remap)
keymap("n", "´B", "`B", remap)
keymap("n", "´C", "`C", remap)
keymap("n", "´D", "`D", remap)
keymap("n", "´F", "`F", remap)
keymap("n", "´G", "`G", remap)
keymap("n", "´H", "`H", remap)
keymap("n", "´J", "`J", remap)
keymap("n", "´K", "`K", remap)
keymap("n", "´L", "`L", remap)
keymap("n", "´M", "`M", remap)
keymap("n", "´N", "`N", remap)
keymap("n", "´P", "`P", remap)
keymap("n", "´Q", "`Q", remap)
keymap("n", "´R", "`R", remap)
keymap("n", "´S", "`S", remap)
keymap("n", "´T", "`T", remap)
keymap("n", "´V", "`V", remap)
keymap("n", "´W", "`W", remap)
keymap("n", "´X", "`X", remap)
keymap("n", "´Z", "`Z", remap)

-- giggity
keymap({ "n", "v", "o" }, "9", "]", remap)
keymap({ "n", "v", "o" }, "8", "[", remap)
keymap({ "n", "v", "o" }, "99", "]]", remap)
keymap({ "n", "v", "o" }, "88", "[[", remap)
keymap({ "n", "v", "o" }, "98", "][", remap)
keymap({ "n", "v", "o" }, "89", "[]", remap)
keymap({ "n", "v", "o" }, "99j", "99j", remap)
keymap({ "n", "v", "o" }, "99k", "99k", remap)
keymap({ "n", "v", "o" }, "88j", "88j", remap)
keymap({ "n", "v", "o" }, "88k", "88k", remap)
keymap({ "n", "v", "o" }, "98j", "98j", remap)
keymap({ "n", "v", "o" }, "98k", "98k", remap)
keymap({ "n", "v", "o" }, "89j", "89j", remap)
keymap({ "n", "v", "o" }, "89k", "89k", remap)
keymap({ "n", "v", "o" }, "9k", "9k", remap)
keymap({ "n", "v", "o" }, "9j", "9j", remap)
keymap({ "n", "v", "o" }, "9l", "9l", remap)
keymap({ "n", "v", "o" }, "9h", "9h", remap)
keymap({ "n", "v", "o" }, "8k", "8k", remap)
keymap({ "n", "v", "o" }, "8j", "8j", remap)
keymap({ "n", "v", "o" }, "8l", "8l", remap)
keymap({ "n", "v", "o" }, "8h", "8h", remap)
