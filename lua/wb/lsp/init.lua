local lsp_installer = require "nvim-lsp-installer"

local lsp_keymaps = require "wb.lsp.keymaps"
local capabilities = require "wb.lsp.capabilities"

require "wb.lsp.custom-server"

local M = {}

local function setup_handlers()
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = {
            spacing = 5,
            prefix = "",
        },
        signs = false, -- rely on highlight styles instead, don't want to clobber signcolumn
    })
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

function M.setup()
    setup_handlers()
    vim.cmd [[ command! LspLog tabnew|lua vim.cmd('e'..vim.lsp.get_log_path()) ]]

    lsp_installer.on_server_ready(function(server)
        local default_opts = {
            on_attach = common_on_attach,
            capabilities = capabilities.create {
                with_snippet_support = server.name ~= "eslintls",
            },
        }

        local server_opts = {
            ["eslintls"] = function()
                default_opts.settings = {
                    format = { enable = true },
                }
                return default_opts
            end,
            ["sumneko_lua"] = function()
                return require("lua-dev").setup {
                    lspconfig = { on_attach = common_on_attach, capabilities = capabilities.create() },
                }
            end,
        }

        server:setup(server_opts[server.name] and server_opts[server.name]() or default_opts)
        vim.cmd [[ do User LspAttachBuffers ]]
    end)
end

return M
