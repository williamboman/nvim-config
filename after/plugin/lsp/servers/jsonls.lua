local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
    return
end

lspconfig.jsonls.setup {
    settings = {
        json = {
            schemas = require("schemastore").json.schemas(),
        },
    },
}
