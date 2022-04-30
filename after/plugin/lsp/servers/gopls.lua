local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
    return
end

lspconfig.gopls.setup {}
