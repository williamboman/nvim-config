local lsp_installer = require("nvim-lsp-installer")

local lsp_keymaps = require("wb.lsp.keymaps")
local capabilities = require("wb.lsp.capabilities")

local M = {}

local function setup_handlers()
    vim.lsp.handlers["textDocument/publishDiagnostics"] =
        vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        {
            virtual_text = {
                spacing = 5,
                prefix = ""
            },
            signs = false -- rely on highlight styles instead, don't want to clobber signcolumn
        }
    )
end

local function common_on_attach(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    lsp_keymaps.buf_set_keymaps(bufnr, "lsp")

    if client.config.flags then
        client.config.flags.allow_incremental_sync = true
    end

    if client.resolved_capabilities.document_highlight then
        lsp_keymaps.buf_autocmd_document_highlight()
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
        local opts = {
            on_attach = common_on_attach,
            capabilities = capabilities.create {
                with_snippet_support = server.name ~= "eslintls"
            }
        }

        server:setup(opts)
    end

    if stop_active_clients then
        -- trigger the FileType autocmd to re-attach servers
        vim.cmd [[ bufdo e ]]
    end
end

return M
