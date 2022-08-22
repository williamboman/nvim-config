local ok, null_ls = pcall(require, "null-ls")
if not ok then
    return
end

local editorconfig_checker = null_ls.builtins.diagnostics.editorconfig_checker
editorconfig_checker._opts.command = "editorconfig-checker"

null_ls.setup {
    sources = {
        editorconfig_checker,
        null_ls.builtins.diagnostics.actionlint,
        null_ls.builtins.diagnostics.codespell,
        null_ls.builtins.diagnostics.gitlint,
        null_ls.builtins.diagnostics.misspell,
        null_ls.builtins.diagnostics.selene,
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.yamllint,
        null_ls.builtins.formatting.cbfmt,
        null_ls.builtins.formatting.jq,
        null_ls.builtins.formatting.ktlint,
        null_ls.builtins.formatting.markdownlint,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.shellharden,
        null_ls.builtins.formatting.stylua,
    },
    on_attach = require "wb.lsp.on-attach",
}
