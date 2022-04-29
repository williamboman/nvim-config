local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
    return
end

lspconfig.sumneko_lua.setup(require("lua-dev").setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "P" },
            },
        },
    },
})
