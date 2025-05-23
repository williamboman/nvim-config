local function buf_set_keymaps(bufnr)
    local function buf_set_keymap(mode, lhs, rhs)
        vim.keymap.set(mode, lhs, rhs, { nowait = true, buffer = bufnr, silent = true })
    end

    if vim.fn.mapcheck("<leader>p", "n") == "" then
        buf_set_keymap("n", "<leader>p", vim.lsp.buf.format)
    end

    -- Code actions
    buf_set_keymap("n", "<leader>r", vim.lsp.buf.rename)
    buf_set_keymap("n", "<space>f", vim.lsp.buf.code_action)
    -- buf_set_keymap("n", "<leader>l", find_and_run_codelens)

    -- Movement
    buf_set_keymap("n", "gD", "<cmd>Glance type_definitions<cr>")
    buf_set_keymap("n", "gd", "<cmd>Glance definitions<cr>")
    buf_set_keymap("n", "gr", "<cmd>Glance references<cr>")
    buf_set_keymap("n", "gqr", vim.lsp.buf.references)
    buf_set_keymap("n", "gbr", function()
        require("glance").open("references", {
            hooks = {
                before_open = function(results, open, jump)
                    local uri = vim.uri_from_bufnr(0)
                    results = vim.tbl_filter(function(location)
                        return (location.uri or location.target_uri) == uri
                    end, results)

                    if #results == 1 then
                        local target_uri = results[1].uri or results[1].targetUri

                        if target_uri == uri then
                            jump(results[1])
                        else
                            open(results)
                        end
                    else
                        open(results)
                    end
                end,
            },
        })
    end)
    buf_set_keymap("n", "gI", "<cmd>Glance implementations<cr>")

    -- Docs
    -- buf_set_keymap("n", "<M-p>", vim.lsp.buf.signature_help)
    -- buf_set_keymap("i", "<M-p>", vim.lsp.buf.signature_help)

    -- buf_set_keymap("n", "<C-p>ws", w(telescope_lsp.workspace_symbols))
    -- buf_set_keymap("n", "<C-p>wd", w(telescope_lsp.workspace_diagnostics))
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client.server_capabilities.completionProvider then
            vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
        end
        if client.server_capabilities.definitionProvider then
            vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
        end

        buf_set_keymaps(bufnr)
    end,
})
