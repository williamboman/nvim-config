local ok, null_ls = pcall(require, "null-ls")
if not ok then
    return
end

null_ls.setup {
    sources = {
        null_ls.builtins.diagnostics.actionlint,
        null_ls.builtins.diagnostics.codespell,
        null_ls.builtins.diagnostics.misspell,
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.formatting.ktlint,
        null_ls.builtins.formatting.markdownlint,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.stylua,
    },
    on_attach = require "wb.lsp.on-attach",
}
