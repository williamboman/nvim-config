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

do
    local showing_diagnostics = true
    local function toggle_diagnostics()
        if showing_diagnostics then
            vim.diagnostic.hide()
        else
            vim.diagnostic.show()
        end
        showing_diagnostics = not showing_diagnostics
    end
    keymap("n", "<M-d>", toggle_diagnostics)
end

keymap("n", "<space>d", function()
    require("telescope.builtin").diagnostics { bufnr = 0 }
end)
