local autocommand
autocommand = vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
    callback = function()
        vim.cmd.packadd "readline.nvim"
        local readline = require "readline"

        vim.keymap.set("!", "<M-f>", readline.forward_word)
        vim.keymap.set("!", "<M-b>", readline.backward_word)
        vim.keymap.set("!", "<C-a>", readline.beginning_of_line)
        vim.keymap.set("!", "<C-e>", readline.end_of_line)
        vim.keymap.set("!", "<M-d>", readline.kill_word)
        vim.keymap.set("!", "<C-w>", readline.backward_kill_word)
        vim.keymap.set("!", "<C-k>", readline.kill_line)
        vim.keymap.set("!", "<C-u>", readline.backward_kill_line)
        vim.keymap.set("!", "<C-y>", function()
            if vim.fn.pumvisible() == 1 then
                return "<C-y>"
            else
                return "<C-r>-"
            end
        end, { expr = true })
        vim.keymap.set("i", "<C-_>", "<C-Bslash><C-o>u")

        vim.api.nvim_del_autocmd(autocommand)
    end
})
