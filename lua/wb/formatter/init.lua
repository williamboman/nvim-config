local M = {}

local function prettier()
    return {
        exe = "prettierd",
        args = { vim.api.nvim_buf_get_name(0) },
        stdin = true,
    }
end

function M.setup()
    require("formatter").setup {
        logging = false,
        filetype = {
            javascript = { prettier },
            javascriptreact = { prettier },
            typescript = { prettier },
            typescriptreact = { prettier },
            json = { prettier },
            lua = {
                function()
                    return {
                        exe = "stylua",
                        args = { "--stdin-filepath", vim.fn.expand "%:t", "-" },
                        stdin = true,
                    }
                end,
            },
            css = { prettier },
            scss = { prettier },
            graphql = { prettier },
            markdown = { prettier },
        },
    }

    require("formatter.util").print = function() end

    vim.api.nvim_set_keymap("n", "<leader>p", "<cmd>MyFormat<CR>", { noremap = true, silent = true })

    -- 2000 timeout on formatting_seq_sync because eslint lsp is slow
    vim.cmd [[ command! MyFormat :lua vim.lsp.buf.formatting_seq_sync({}, 2000); vim.cmd "Format" <CR> ]]
end

return M
