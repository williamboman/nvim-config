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
    ensure_installed = { "sumneko_lua", "jsonls", "yamlls" },
    automatic_installation = vim.fn.hostname == "Williams-MacBook-Air.local",
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

--- @return fun() @function that calls the provided fn, but with no args
local function w(fn)
    return function()
        return fn()
    end
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
        callback = w(vim.lsp.buf.clear_references),
    })
end

---@param bufnr number
local function buf_autocmd_codelens(bufnr)
    local group = vim.api.nvim_create_augroup("lsp_document_codelens", {})
    vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost", "CursorHold" }, {
        buffer = bufnr,
        group = group,
        callback = w(vim.lsp.codelens.refresh),
    })
end

local function goto_prev_error()
    vim.diagnostic.goto_prev { severity = "Error" }
end

local function goto_next_error()
    vim.diagnostic.goto_next { severity = "Error" }
end

-- Finds and runs the closest codelens (searches upwards only)
local function find_and_run_codelens()
    local bufnr = vim.api.nvim_get_current_buf()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local lenses = vim.lsp.codelens.get(bufnr)

    lenses = vim.tbl_filter(function(lense)
        return lense.range.start.line < row
    end, lenses)

    if #lenses == 0 then
        return vim.notify "Could not find codelens to run."
    end

    table.sort(lenses, function(a, b)
        return a.range.start.line > b.range.start.line
    end)

    vim.api.nvim_win_set_cursor(0, { lenses[1].range.start.line + 1, 0 })
    vim.lsp.codelens.run()
    vim.api.nvim_win_set_cursor(0, { row, col }) -- restore cursor, TODO: also restore position
end

---@param bufnr number
local function buf_set_keymaps(bufnr)
    local function buf_set_keymap(mode, lhs, rhs)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
    end

    buf_set_keymap("n", "<leader>p", vim.lsp.buf.formatting)

    -- Code actions
    buf_set_keymap("n", "<leader>r", vim.lsp.buf.rename)
    buf_set_keymap("n", "<space>f", vim.lsp.buf.code_action)

    buf_set_keymap("n", "<leader>l", find_and_run_codelens)

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
        buf_set_keymap(mode, "[e", goto_prev_error)
        buf_set_keymap(mode, "]e", goto_next_error)
        buf_set_keymap(mode, "[E", vim.diagnostic.goto_prev)
        buf_set_keymap(mode, "]E", vim.diagnostic.goto_next)
    end
    buf_set_keymap("n", "].", vim.diagnostic.open_float)
end

local function common_on_attach(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    buf_set_keymaps(bufnr)

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
