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

function _G.install_preferred_lsp()
    local servers = {
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
        "ltex",
        "prismals",
        "pyright",
        "quick_lint_js",
        "rust_analyzer",
        "sqls",
        "sumneko_lua",
        "terraformls",
        "tsserver",
        "vimls",
        "vuels",
        "yamlls",
    }

    for _, server_name in ipairs(servers) do
        local ok, server = lsp_installer.get_server(server_name)
        if ok and not server:is_installed() then
            lsp_installer.install(server.name)
        end
    end
end

function M.setup()
    setup_handlers()
    local coq = require "coq"
    vim.cmd [[ command! LspLog exe 'tabnew ' .. luaeval("vim.lsp.get_log_path()") ]]
    vim.cmd [[ command! LspInstallPreferred call v:lua.install_preferred_lsp() ]]

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
            flags = {
                debounce_text_changes = 150,
            },
        }

        if server.name == "rust_analyzer" then
            require("rust-tools").setup {
                server = vim.tbl_deep_extend("force", server:get_default_options(), default_opts),
            }
            server:attach_buffers()
            return
        end

        local server_opts = {
            ["ltex"] = function()
                return vim.tbl_deep_extend("force", default_opts, {
                    flags = {
                        debounce_text_changes = 2000,
                    },
                })
            end,
            ["eslintls"] = function()
                return vim.tbl_deep_extend("force", default_opts, {
                    settings = {
                        format = {
                            enable = true,
                        },
                    },
                })
            end,
            ["sumneko_lua"] = function()
                return require("lua-dev").setup {
                    lspconfig = vim.tbl_deep_extend("force", default_opts, {
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "P" },
                                },
                            },
                        },
                    }),
                }
            end,
            ["tsserver"] = function()
                local tsutils = require "nvim-lsp-ts-utils"
                return vim.tbl_deep_extend("force", default_opts, {
                    init_options = {
                        hostInfo = "neovim",
                        preferences = {
                            includeInlayParameterNameHints = "none",
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = false,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                    on_attach = function(client, bufnr)
                        client.resolved_capabilities.document_formatting = false
                        common_on_attach(client, bufnr)
                        tsutils.setup {}
                        tsutils.setup_client(client)
                    end,
                })
            end,
            ["yamlls"] = function()
                return vim.tbl_deep_extend("force", default_opts, {
                    settings = {
                        yaml = {
                            hover = true,
                            completion = true,
                            validate = true,
                            schemas = require("schemastore").json.schemas(),
                        },
                    },
                })
            end,
            ["jsonls"] = function()
                return vim.tbl_deep_extend("force", default_opts, {
                    settings = {
                        json = {
                            schemas = require("schemastore").json.schemas(),
                        },
                    },
                })
            end,
            ["jdtls"] = function()
                return vim.tbl_deep_extend("force", default_opts, {
                    handlers = {
                        ["language/status"] = require "wb.lsp.jdtls-progress"(),
                    },
                })
            end,
        }

        server:setup(
            coq.lsp_ensure_capabilities(server_opts[server.name] and server_opts[server.name]() or default_opts)
        )
    end)

    local null_ls = require "null-ls"
    null_ls.setup {
        sources = {
            null_ls.builtins.formatting.prettierd,
            null_ls.builtins.formatting.stylua,
            null_ls.builtins.diagnostics.shellcheck,
            null_ls.builtins.completion.spell,
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
