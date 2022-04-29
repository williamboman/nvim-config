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

    require("lsp_signature").on_attach({
        bind = true,
        floating_window = false,
        hint_prefix = "",
        hint_scheme = "Comment",
    }, bufnr)
end

function M.setup()
    require("nvim-lsp-installer").setup {
        automatic_installation = true,
        log_level = vim.log.levels.DEBUG,
        ui = {
            icons = {
                server_installed = "",
                server_pending = "",
                server_uninstalled = "",
            },
        },
    }
    local lspconfig = require "lspconfig"
    local util = require "lspconfig.util"
    local coq = require "coq"

    setup_handlers()
    vim.cmd [[ command! LspLog exe 'tabnew ' .. luaeval("vim.lsp.get_log_path()") ]]

    util.on_setup = util.add_hook_after(util.on_setup, function(config)
        if config.on_attach then
            config.on_attach = util.add_hook_after(config.on_attach, common_on_attach)
        else
            config.on_attach = common_on_attach
        end
        config.capabilities = capabilities.create()
        config.capabilities = coq.lsp_ensure_capabilities(config).capabilities
    end)

    local server_settings = {
        ["ltex"] = {
            flags = {
                debounce_text_changes = 2000,
            },
        },
        ["eslint"] = {
            settings = {
                format = { enable = true },
            },
        },
        ["jdtls"] = {
            handlers = {
                ["language/status"] = require "wb.lsp.jdtls-progress"(),
            },
        },
        ["sumneko_lua"] = require("lua-dev").setup {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "P" },
                    },
                },
            },
        },
        ["yamlls"] = {
            settings = {
                yaml = {
                    hover = true,
                    completion = true,
                    validate = true,
                    schemas = require("schemastore").json.schemas(),
                },
            },
        },
        ["jsonls"] = {
            settings = {
                json = {
                    schemas = require("schemastore").json.schemas(),
                },
            },
        },
    }

    require("typescript").setup {}
    require("rust-tools").setup {}

    for _, server in ipairs {
        "bashls",
        "clangd",
        "cmake",
        "cssls",
        "dockerls",
        "eslint",
        "graphql",
        "html",
        "jdtls",
        "jsonls",
        "lemminx",
        "ltex",
        "prismals",
        "pylsp",
        "sumneko_lua",
        "taplo",
        "terraformls",
        "vimls",
        "yamlls",
    } do
        lspconfig[server].setup(server_settings[server] or {})
    end

    local null_ls = require "null-ls"
    null_ls.setup {
        sources = {
            null_ls.builtins.formatting.prettierd,
            null_ls.builtins.formatting.stylua,
            null_ls.builtins.diagnostics.shellcheck,
        },
    }
    require("fidget").setup {
        window = {
            relative = "editor",
        },
    }
end

return M
