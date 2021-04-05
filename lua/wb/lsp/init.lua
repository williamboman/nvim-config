local lsp_installer = require('nvim-lsp-installer')

local lsp_keymaps = require('wb.lsp.keymaps')
local capabilities = require('wb.lsp.capabilities')

local M = {}

local function setup_handlers()
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = {
                spacing = 5,
                prefix = '--'
            },
            signs = false -- rely on highlight styles instead, don't want to clobber signcolumn
        }
    )
end

local function common_on_attach(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    lsp_keymaps.buf_set_keymaps(bufnr, "lsp")

    if client.config.flags then
        client.config.flags.allow_incremental_sync = true
    end

    if client.resolved_capabilities.document_highlight then
        lsp_keymaps.buf_autocmd_document_highlight()
    end

    local opts = { noremap=true, silent=true }
    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap('n', '<leader>p', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap('n', '<leader>p', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
    else
        buf_set_keymap('n', '<leader>p', '<cmd>echohl WarningMsg | echo "Formatting not supported by LSP." | echohl None<CR>', opts)
    end

end

function M.setup(stop_active_clients)
	if stop_active_clients then
		vim.lsp.stop_client(vim.lsp.get_active_clients(), true)
	end

	setup_handlers()

    vim.cmd [[ command! LspReload :lua require'wb.lsp'.setup(true) ]]

	local installed_servers = lsp_installer.get_installed_servers()

	for _, server in pairs(installed_servers) do
		server:setup {
			on_attach = common_on_attach,
            capabilities = capabilities.create {
                with_snippet_support = server.name ~= 'eslintls'
            }
		}
	end

end

return M
