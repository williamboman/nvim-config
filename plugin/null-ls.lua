local ok, null_ls = pcall(require, "null-ls")
if not ok then
    return
end

null_ls.setup {
    sources = {
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.diagnostics.shellcheck,
    },
    on_attach = require "wb.lsp.on-attach",
}
