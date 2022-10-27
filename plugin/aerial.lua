local ok, aerial = pcall(require, "aerial")
if not ok then
    return
end

aerial.setup {
    layout = {
        width = 40,
        default_direction = "right",
        placement = "edge",
    },
}

vim.keymap.set("n", "<space>s", "<cmd>AerialToggle<CR>")

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        aerial.on_attach(client, bufnr)
    end,
})
