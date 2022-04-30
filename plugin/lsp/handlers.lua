local rename = vim.lsp.handlers["textDocument/rename"]

-- Populates the quickfix list with all rename locations.
vim.lsp.handlers["textDocument/rename"] = function(err, result, ...)
    rename(err, result, ...)
    if not result or not result.changes then
        -- print error message?
        return
    end

    local entries = {}
    -- TODO support documentChanges?
    for uri, edits in pairs(result.changes) do
        local bufnr = vim.uri_to_bufnr(uri)

        for _, edit in ipairs(edits) do
            local start_line = edit.range.start.line + 1
            local line = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, start_line, false)[1]

            table.insert(entries, {
                bufnr = bufnr,
                lnum = start_line,
                col = edit.range.start.character + 1,
                text = line,
            })
        end
    end
    vim.fn.setqflist(entries, "r")
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
        spacing = 5,
        prefix = "",
    },
    signs = false, -- rely on highlight styles instead, don't want to clobber signcolumn
})

local codeLens = vim.lsp.handlers["textDocument/codeLens"]

vim.lsp.handlers["textDocument/codeLens"] = function(err, ...)
    if err then
        -- silence errors
        return
    end
    codeLens(nil, ...)
end
