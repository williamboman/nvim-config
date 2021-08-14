local M = {}

local function prettier()
    return {
        exe = "prettierd",
        args = {vim.api.nvim_buf_get_name(0)},
        stdin = true
    }
end

function M.setup()
    -- 2000 timeout on formatting_seq_sync because eslint lsp is slow
    vim.cmd [[command! MyFormat :Format|lua vim.lsp.buf.formatting_seq_sync({}, 2000)<CR>]]

    require("formatter").setup(
        {
            logging = false,
            filetype = {
                javascript = {prettier},
                javascriptreact = {prettier},
                typescript = {prettier},
                typescriptreact = {prettier},
                json = {prettier},
                lua = {
                    function()
                        return {
                            exe = "luafmt",
                            args = {"--stdin"},
                            stdin = true
                        }
                    end
                },
                css = {prettier},
                scss = {prettier},
                graphql = {prettier},
                markdown = {prettier}
            }
        }
    )

    vim.api.nvim_set_keymap("n", "<leader>p", "<cmd>MyFormat<CR>", {noremap = true, silent = true})
end

return M
