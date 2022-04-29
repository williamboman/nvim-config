local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
    return
end

lspconfig.ltex.setup {
    flags = {
        debounce_text_changes = 2000,
    },
}
