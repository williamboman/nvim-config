local lsp_installer = require "nvim-lsp-installer"

local lsp_keymaps = require "wb.lsp.keymaps"
local capabilities = require "wb.lsp.capabilities"

require "wb.lsp.handlers"
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

    lsp_keymaps.buf_set_keymaps(bufnr)

    if client.config.flags then
        client.config.flags.allow_incremental_sync = true
    end

    if client.resolved_capabilities.document_highlight then
        lsp_keymaps.buf_autocmd_document_highlight()
    end
end

function M.setup()
    setup_handlers()
    local coq = require "coq"
    vim.cmd [[ command! LspLog exe 'tabnew ' .. luaeval("vim.lsp.get_log_path()") ]]

    lsp_installer.settings {
        log_level = vim.log.levels.DEBUG,
        ui = {
            icons = {
                server_installed = "",
                server_pending = "",
                server_uninstalled = "",
            },
        },
    }

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

        server:setup(
            coq.lsp_ensure_capabilities(server_opts[server.name] and server_opts[server.name]() or default_opts)
        )
        vim.cmd [[ do User LspAttachBuffers ]]
    end)
end

return M
