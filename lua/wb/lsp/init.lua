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

    require("lsp_signature").on_attach({
        bind = true,
        floating_window = false,
        hint_prefix = "",
        hint_scheme = "Comment",
    }, bufnr)
end

function M.setup()
    require("nvim-lsp-installer").setup {
        ensure_installed = {
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
            "rust_analyzer",
            "sumneko_lua",
            "taplo",
            "terraformls",
            "tsserver",
            "vimls",
            "vuels",
            "yamlls",
        },
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
    local coq = require "coq"

    setup_handlers()
    vim.cmd [[ command! LspLog exe 'tabnew ' .. luaeval("vim.lsp.get_log_path()") ]]

    local default_opts = coq.lsp_ensure_capabilities {
        on_attach = common_on_attach,
        capabilities = capabilities.create {
            with_snippet_support = true,
        },
        flags = {
            debounce_text_changes = 150,
        },
    }

    local function with_defaults(opts)
        return vim.tbl_extend("force", default_opts, opts)
    end

    require("typescript").setup { server = default_opts }
    require("rust-tools").setup { server = default_opts }

    lspconfig.ltex.setup(with_defaults {
        flags = {
            debounce_text_changes = 2000,
        },
    })

    lspconfig.eslint.setup(with_defaults {
        settings = {
            format = { enable = true },
        },
    })

    lspconfig.sumneko_lua.setup(require("lua-dev").setup(with_defaults {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "P" },
                },
            },
        },
    }))

    lspconfig.yamlls.setup(with_defaults {
        settings = {
            yaml = {
                hover = true,
                completion = true,
                validate = true,
                schemas = require("schemastore").json.schemas(),
            },
        },
    })

    lspconfig.jsonls.setup(with_defaults {
        settings = {
            json = {
                schemas = require("schemastore").json.schemas(),
            },
        },
    })

    lspconfig.jdtls.setup(with_defaults {
        handlers = {
            ["language/status"] = require "wb.lsp.jdtls-progress"(),
        },
    })

    local null_ls = require "null-ls"
    null_ls.setup {
        sources = {
            null_ls.builtins.formatting.prettierd,
            null_ls.builtins.formatting.stylua,
            null_ls.builtins.diagnostics.shellcheck,
        },
        on_attach = common_on_attach,
    }
    require("fidget").setup {
        window = {
            relative = "editor",
        },
    }
end

return M
