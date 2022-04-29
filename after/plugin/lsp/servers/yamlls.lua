local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
    return
end

lspconfig.yamlls.setup {
    settings = {
        yaml = {
            hover = true,
            completion = true,
            validate = true,
            schemas = require("schemastore").json.schemas(),
        },
    },
}
