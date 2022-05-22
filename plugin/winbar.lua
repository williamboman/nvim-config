vim.api.nvim_create_autocmd({ "BufWinEnter", "TermOpen" }, {
    pattern = "*",
    callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
        if buftype == "" or buftype == "help" then
            vim.cmd [[setlocal winbar=%{%v:lua.require'wb.winbar'.winbar()%}]]
        else
            vim.cmd [[setlocal winbar=]]
        end
    end,
})
