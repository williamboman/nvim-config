local status_ok, hints = pcall(require, "lsp-inlayhints")
if not status_ok then
    return
end

local group = vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
        if not (args.data and args.data.client_id) then
            return
        end

        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        hints.on_attach(client, bufnr)
    end,
})

hints.setup {
    inlay_hints = {
        parameter_hints = {
            show = true,
        },
        type_hints = {
            show = true,
        },
    },
}
