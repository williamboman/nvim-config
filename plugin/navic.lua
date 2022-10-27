local ok, navic = pcall(require, "nvim-navic")
if not ok then
    return
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.supports_method "textDocument/documentSymbol" then
            navic.attach(client, bufnr)
        end
    end,
})
