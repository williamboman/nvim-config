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
                    lspconfig = default_opts,
                }
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
                -- Non-standard notification that can be used to display progress
                local function create_language_status_handler()
                    ---@param result {type:"Starting"|"Started"|"ServiceReady", message:string}
                    ---@type table<string, boolean>
                    local tokens = {}
                    ---@type table<string, boolean>
                    local ready_projects = {}
                    return function(_, result, ctx)
                        local cwd = vim.loop.cwd()
                        if ready_projects[cwd] then
                            return
                        end
                        local token = tokens[cwd] or vim.tbl_count(tokens)
                        if result.type == "Starting" and not tokens[cwd] then
                            tokens[cwd] = token
                            vim.lsp.handlers["$/progress"](nil, {
                                token = token,
                                value = {
                                    kind = "begin",
                                    title = "jdtls",
                                    message = result.message,
                                    percentage = 0,
                                },
                            }, ctx)
                        elseif result.type == "Starting" then
                            local _, percentage_index = string.find(result.message, "^%d%d?%d?")
                            local percentage = 0
                            local message = result.message
                            if percentage_index then
                                percentage = tonumber(string.sub(result.message, 1, percentage_index))
                                message = string.sub(result.message, percentage_index + 3)
                            end

                            vim.lsp.handlers["$/progress"](nil, {
                                token = token,
                                value = {
                                    kind = "report",
                                    message = message,
                                    percentage = percentage,
                                },
                            }, ctx)
                        elseif result.type == "Started" then
                            vim.lsp.handlers["$/progress"](nil, {
                                token = token,
                                value = {
                                    kind = "report",
                                    message = result.message,
                                    percentage = 100,
                                },
                            }, ctx)
                        elseif result.type == "ServiceReady" then
                            ready_projects[cwd] = true
                            vim.lsp.handlers["$/progress"](nil, {
                                token = token,
                                value = {
                                    kind = "end",
                                    message = result.message,
                                },
                            }, ctx)
                        end
                    end
                end

                return vim.tbl_deep_extend("force", default_opts, {
                    handlers = {
                        ["language/status"] = create_language_status_handler(),
                    },
                })
            end,
        }

        server:setup(
            coq.lsp_ensure_capabilities(server_opts[server.name] and server_opts[server.name]() or default_opts)
        )
        vim.cmd [[ do User LspAttachBuffers ]]
    end)
end

return M
