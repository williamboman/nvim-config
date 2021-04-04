local builtin = require('telescope.builtin')

local M = {}

M.code_actions = function ()
    builtin.lsp_code_actions()
end

M.range_code_actions = function ()
    builtin.lsp_range_code_actions()
end

M.document_diagnostics = function ()
    builtin.lsp_document_diagnostics()
end

M.definitions = function ()
    builtin.lsp_definitions()
end

M.references = function ()
    builtin.lsp_references()
end

return M
