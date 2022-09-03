local bufnr = vim.api.nvim_get_current_buf()

vim.cmd.startinsert()

vim.keymap.set("n", "<C-p>", [[<cmd>startinsert | call feedkeys("\<C-p>")<cr>]], { buffer = true, nowait = true })

vim.api.nvim_create_autocmd({ "BufLeave" }, {
    buffer = bufnr,
    callback = function()
        if not vim.b.last_insert_line then
            return
        end
        local bufinfo = assert(vim.fn.getbufinfo(vim.fn.bufnr())[1])
        vim.b.should_trigger_insert_mode = bufinfo.lnum == vim.b.last_insert_line
    end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    buffer = bufnr,
    callback = function()
        if vim.b.should_trigger_insert_mode then
            vim.cmd.startinsert()
        end
        vim.b.should_trigger_insert_mode = nil
    end,
})

vim.api.nvim_create_autocmd({ "TermLeave" }, {
    buffer = bufnr,
    callback = function()
        local bufinfo = assert(vim.fn.getbufinfo(vim.fn.bufnr())[1])
        vim.b.last_insert_line = bufinfo.lnum
    end,
})
