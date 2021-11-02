local M = {}

local default_opts = {
    with_snippet_support = true,
}

function M.create(opts)
    opts = opts or default_opts
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = opts.with_snippet_support
    if opts.with_snippet_support then
        capabilities.textDocument.completion.completionItem.resolveSupport = {
            properties = {
                "documentation",
                "detail",
                "additionalTextEdits",
            },
        }
    end
    return capabilities
end

return M
