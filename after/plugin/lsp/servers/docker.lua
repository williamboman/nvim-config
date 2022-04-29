local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
    return
end

lspconfig.dockerls.setup {}
