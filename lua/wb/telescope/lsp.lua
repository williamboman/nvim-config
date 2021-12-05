local builtin = require "telescope.builtin"

local M = {}

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

M.implementations = function()
    builtin.lsp_implementations()
end

M.workspace_symbols = function()
    local query = vim.fn.input "Query >"
    if query ~= "" then
        vim.cmd("Telescope lsp_workspace_symbols query=" .. query)
    else
        builtin.lsp_workspace_symbols()
    end
end

M.document_symbols = function()
    local symbols = {
        "All",
        "Variable",
        "Function",
        "Constant",
        "Class",
        "Property",
        "Method",
        "Enum",
        "Interface",
        "Boolean",
        "Number",
        "String",
        "Array",
        "Constructor",
    }

    vim.ui.select(symbols, { prompt = "Select which symbol" }, function(item)
        if item == "All" then
            builtin.lsp_document_symbols()
        else
            builtin.lsp_document_symbols { symbols = item }
        end
    end)
end

return M
