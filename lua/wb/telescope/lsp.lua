local builtin = require("telescope.builtin")

local M = {}

M.code_actions = function()
    builtin.lsp_code_actions()
end

M.range_code_actions = function()
    builtin.lsp_range_code_actions()
end

M.document_diagnostics = function()
    builtin.lsp_document_diagnostics()
end

M.workspace_diagnostics = function()
    builtin.lsp_workspace_diagnostics()
end

M.definitions = function()
    builtin.lsp_definitions()
end

M.references = function()
    builtin.lsp_references()
end

M.workspace_symbols = function()
    local query = vim.fn.input("Query >")
    if query then
        vim.cmd("Telescope lsp_workspace_symbols query=" .. query)
    else
        builtin.lsp_workspace_symbols()
    end
end

M.document_symbols = function()
    builtin.lsp_document_symbols()
end

return M
