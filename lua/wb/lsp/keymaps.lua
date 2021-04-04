local M = {}

function M.buf_autocmd_document_highlight()
    vim.api.nvim_exec([[
    augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]], false)
end

_G.lsp_popup_opts = {
    show_header = false,
}

-- @param bufnr (number)
-- @param type (string) 'jdtls' | 'lsp'
function M.buf_set_keymaps(bufnr, type)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local opts = { noremap=true, silent=true }

    -- Code actions
    buf_set_keymap('n', '<leader>r', "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    if type == "jdtls" then
        buf_set_keymap('n', '<leader>qf', "<cmd>lua require'jdtls'.code_action()<CR>", opts)
        buf_set_keymap('v', '<leader>f', "<cmd>lua require'jdtls'.code_action(true)<CR>", opts)
        buf_set_keymap('n', '<leader>ev', "<cmd>lua require'jdtls'.extract_variable()<CR>", opts)
        buf_set_keymap('v', '<C-m>', "<cmd>lua require'jdtls'.extract_method(true)<CR>", opts)
    else
        buf_set_keymap('n', '<space>f', "<cmd>lua require'wb.telescope.lsp'.code_actions()<CR>", opts)
        buf_set_keymap('v', '<space>f', "<cmd><C-U>lua require'wb.telescope.lsp'.range_code_actions()<CR>", opts)
    end

    -- Movement
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', "<cmd>lua require'wb.telescope.lsp'.definitions()<CR>", opts)
    buf_set_keymap('n', 'gr', "<cmd>lua require'wb.telescope.lsp'.references()<CR>", opts)

    -- Docs
    buf_set_keymap('n', 'K', "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap('n', '<leader>t', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('i', '<C-t>', "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

    -- Diagnostics
    buf_set_keymap('n', '<space>d', "<cmd>lua require'wb.telescope.lsp'.document_diagnostics()<CR>", opts)
    buf_set_keymap('n', '[E', "<cmd>lua vim.lsp.diagnostic.goto_prev({ popup_opts = lsp_popup_opts })<CR>", opts)
    for _, mode in pairs({'n', 'v'}) do
        buf_set_keymap(mode, ']E', "<cmd>lua vim.lsp.diagnostic.goto_next({ severity_limit = 'Error', popup_opts = lsp_popup_opts })<CR>", opts)
        buf_set_keymap(mode, '[e', "<cmd>lua vim.lsp.diagnostic.goto_prev({ severity_limit = 'Error', popup_opts = lsp_popup_opts })<CR>", opts)
        buf_set_keymap(mode, ']e', "<cmd>lua vim.lsp.diagnostic.goto_next({ severity_limit = 'Error', popup_opts = lsp_popup_opts })<CR>", opts)
    end
    buf_set_keymap('n', '].', "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics(lsp_popup_opts)<CR>", opts)
end

return M
