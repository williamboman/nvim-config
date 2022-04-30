local ok, util = pcall(require, "lspconfig.util")
if not ok then
    return
end

local ts_utils = require "nvim-treesitter.ts_utils"
local lsp_signature = require "lsp_signature"
local null_ls = require "null-ls"

local telescope_lsp = require "wb.telescope.lsp"

vim.api.nvim_create_user_command("LspLog", [[exe 'tabnew ' .. luaeval("vim.lsp.get_log_path()")]], {})

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

---@param opts table|nil
local function create_capabilities(opts)
    local default_opts = {
        with_snippet_support = true,
    }
    opts = opts or default_opts
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = opts.with_snippet_support
    if opts.with_snippet_support then
        capabilities.textDocument.completion.completionItem.resolveSupport = {
            properties = {
                "documentation",
                "detail",
                "additionalTextEdits",
            },
        }
    end
    return capabilities
end

local function highlight_references()
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

---@param bufnr number
local function buf_autocmd_document_highlight(bufnr)
    local group = vim.api.nvim_create_augroup("lsp_document_highlight", {})
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = bufnr,
        group = group,
        callback = highlight_references,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = bufnr,
        group = group,
        callback = vim.lsp.buf.clear_references,
    })
end

---@param bufnr number
local function buf_autocmd_codelens(bufnr)
    local group = vim.api.nvim_create_augroup("lsp_document_codelens", {})
    vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost", "CursorHold" }, {
        buffer = bufnr,
        group = group,
        callback = vim.lsp.codelens.refresh,
    })
end

---@param client table
---@param bufnr number
local function buf_set_keymaps(client, bufnr)
    local function buf_set_keymap(mode, lhs, rhs)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
    end

    buf_set_keymap("n", "<leader>p", vim.lsp.buf.formatting)

    -- Code actions
    buf_set_keymap("n", "<leader>r", vim.lsp.buf.rename)
    buf_set_keymap("n", "<space>f", vim.lsp.buf.code_action)

    if client.supports_method "textDocument/codeLens" then
        buf_set_keymap("n", "<leader>l", vim.lsp.codelens.run)
    end

    -- Movement
    buf_set_keymap("n", "gD", vim.lsp.buf.declaration)
    buf_set_keymap("n", "gd", telescope_lsp.definitions)
    buf_set_keymap("n", "gr", telescope_lsp.references)
    buf_set_keymap("n", "gbr", telescope_lsp.buffer_references)
    buf_set_keymap("n", "gI", telescope_lsp.implementations)
    buf_set_keymap("n", "<space>s", telescope_lsp.document_symbols)

    -- Docs
    buf_set_keymap("n", "K", vim.lsp.buf.hover)
    buf_set_keymap("n", "<leader>t", vim.lsp.buf.signature_help)
    buf_set_keymap("i", "<C-k>", vim.lsp.buf.signature_help)

    -- Diagnostics
    buf_set_keymap("n", "<space>d", telescope_lsp.document_diagnostics)

    buf_set_keymap("n", "<space>ws", telescope_lsp.workspace_symbols)
    buf_set_keymap("n", "<space>wd", telescope_lsp.workspace_diagnostics)

    for _, mode in pairs { "n", "v" } do
        buf_set_keymap(mode, "[e", function()
            vim.diagnostic.goto_prev { severity = "Error" }
        end)
        buf_set_keymap(mode, "]e", function()
            vim.diagnostic.goto_next { severity = "Error" }
        end)
        buf_set_keymap(mode, "[E", vim.diagnostic.goto_prev)
        buf_set_keymap(mode, "]E", vim.diagnostic.goto_next)
    end
    buf_set_keymap("n", "].", vim.diagnostic.open_float)
end

local function common_on_attach(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    buf_set_keymaps(client, bufnr)

    if client.config.flags then
        client.config.flags.allow_incremental_sync = true
    end

    if client.supports_method "textDocument/documentHighlight" then
        buf_autocmd_document_highlight(bufnr)
    end

    if client.supports_method "textDocument/codeLens" then
        buf_autocmd_codelens(bufnr)
        vim.schedule(vim.lsp.codelens.refresh)
    end

    lsp_signature.on_attach({
        bind = true,
        floating_window = false,
        hint_prefix = "",
        hint_scheme = "Comment",
    }, bufnr)
end

util.on_setup = util.add_hook_after(util.on_setup, function(config)
    if config.on_attach then
        config.on_attach = util.add_hook_after(config.on_attach, common_on_attach)
    else
        config.on_attach = common_on_attach
    end
    config.capabilities = create_capabilities()
    config.capabilities = coq.lsp_ensure_capabilities(config).capabilities
end)

null_ls.setup {
    sources = {
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.diagnostics.shellcheck,
    },
    on_attach = common_on_attach,
}
