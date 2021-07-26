local M = {}

local function prettier()
    return {
        exe = "prettierd",
        args = { vim.api.nvim_buf_get_name(0) },
        stdin = true
    }
end

M.filetype = {
    javascript = {prettier},
    javascriptreact = {prettier},
    typescript = {prettier},
    typescriptreact = {prettier},
    json = {prettier},
    css = {prettier},
    scss = {prettier},
    graphql = {prettier},
    markdown = {prettier},
}

function _G.formatter()
    vim.lsp.buf.formatting_seq_sync({}, 2000) -- 2000ms timeout, eslint is slow
    vim.cmd [[:Format]]
end

function M.setup()
    require("formatter").setup({
        logging = false,
        filetype = M.filetype,
    })

    vim.api.nvim_set_keymap("n", "<leader>p", "<cmd>call v:lua.formatter()<CR>", {noremap=true, silent=true})
end

return M
