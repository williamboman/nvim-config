local ts_utils = require "nvim-treesitter.ts_utils"

local M = {}

function M.buf_autocmd_document_highlight()
    vim.api.nvim_exec(
        [[
    augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold,CursorHoldI <buffer> call v:lua.my_document_highlight()
        autocmd CursorMoved,CursorMovedI <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]],
        false
    )
end

function _G.my_document_highlight()
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

_G.lsp_popup_opts = {
    show_header = false,
}

-- @param bufnr (number)
function M.buf_set_keymaps(bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local opts = { noremap = true, silent = true }

    buf_set_keymap("n", "<leader>p", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

    -- Code actions
    buf_set_keymap("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    buf_set_keymap("v", "<space>f", "<cmd><C-U>lua vim.lsp.buf.range_code_action()<CR>", opts)

    -- Movement
    buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<cmd>lua require'wb.telescope.lsp'.definitions()<CR>", opts)
    buf_set_keymap("n", "gr", "<cmd>lua require'wb.telescope.lsp'.references()<CR>", opts)
    buf_set_keymap("n", "gI", "<cmd>lua require'wb.telescope.lsp'.implementations()<CR>", opts)
    buf_set_keymap("n", "<space>s", "<cmd>lua require'wb.telescope.lsp'.document_symbols()<CR>", opts)

    -- Docs
    buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "<leader>t", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

    -- Diagnostics
    buf_set_keymap("n", "<space>d", "<cmd>lua require'wb.telescope.lsp'.document_diagnostics()<CR>", opts)

    for _, mode in pairs { "n", "v" } do
        buf_set_keymap(mode, "[e", "<cmd>lua vim.diagnostic.goto_prev({ severity = 'Error' })<CR>", opts)
        buf_set_keymap(mode, "]e", "<cmd>lua vim.diagnostic.goto_next({ severity = 'Error' })<CR>", opts)
        buf_set_keymap(mode, "[E", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
        buf_set_keymap(mode, "]E", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    end
    buf_set_keymap("n", "].", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
end

return M
