local ts_utils = require "nvim-treesitter.ts_utils"

local telescope_lsp = require "wb.telescope.lsp"

local M = {}

local function highlight_references()
    local node = ts_utils.get_node_at_cursor()
    while node ~= nil do
        local node_type = node:type()
        if
            node_type == "string"
            or node_type == "string_fragment"
            or node_type == "template_string"
            or node_type == "document" -- for inline gql`` strings
        then
            -- who wants to highlight a string? i don't. yuck
            return
        end
        node = node:parent()
    end
    vim.lsp.buf.document_highlight()
end

---@param bufnr number
function M.buf_autocmd_document_highlight(bufnr)
    local group = vim.api.nvim_create_augroup("lsp_document_highlight", {})
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = bufnr,
        group = group,
        callback = highlight_references,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = bufnr,
        group = group,
        callback = vim.lsp.buf.clear_references,
    })
end

-- @param bufnr number
function M.buf_set_keymaps(bufnr)
    local function buf_set_keymap(mode, lhs, rhs)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
    end

    buf_set_keymap("n", "<leader>p", vim.lsp.buf.formatting)

    -- Code actions
    buf_set_keymap("n", "<leader>r", vim.lsp.buf.rename)
    buf_set_keymap("n", "<space>f", vim.lsp.buf.code_action)

    -- Movement
    buf_set_keymap("n", "gD", vim.lsp.buf.declaration)
    buf_set_keymap("n", "gd", telescope_lsp.definitions)
    buf_set_keymap("n", "gr", telescope_lsp.references)
    buf_set_keymap("n", "gbr", telescope_lsp.buffer_references)
    buf_set_keymap("n", "gI", telescope_lsp.implementations)
    buf_set_keymap("n", "<space>s", telescope_lsp.document_symbols)

    -- Docs
    buf_set_keymap("n", "K", vim.lsp.buf.hover)
    buf_set_keymap("n", "<leader>t", vim.lsp.buf.signature_help)
    buf_set_keymap("i", "<C-k>", vim.lsp.buf.signature_help)

    -- Diagnostics
    buf_set_keymap("n", "<space>d", telescope_lsp.document_diagnostics)

    buf_set_keymap("n", "<space>ws", telescope_lsp.workspace_symbols)
    buf_set_keymap("n", "<space>wd", telescope_lsp.workspace_diagnostics)

    for _, mode in pairs { "n", "v" } do
        buf_set_keymap(mode, "[e", function()
            vim.diagnostic.goto_prev { severity = "Error" }
        end)
        buf_set_keymap(mode, "]e", function()
            vim.diagnostic.goto_next { severity = "Error" }
        end)
        buf_set_keymap(mode, "[E", vim.diagnostic.goto_prev)
        buf_set_keymap(mode, "]E", vim.diagnostic.goto_next)
    end
    buf_set_keymap("n", "].", vim.diagnostic.open_float)
end

return M
