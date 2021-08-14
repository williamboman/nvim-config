local M = {}

M.setup = function()
    require("gitsigns").setup {
        keymaps = {},
    }

    local mapopts = { noremap = true }

    vim.api.nvim_set_keymap("n", "]c", '<cmd>lua require"gitsigns".next_hunk()<CR>', mapopts)
    vim.api.nvim_set_keymap("n", "[c", '<cmd>lua require"gitsigns".prev_hunk()<CR>', mapopts)

    vim.api.nvim_set_keymap("n", "<leader>ga", '<cmd>lua require"gitsigns".stage_hunk()<CR>', mapopts)
    vim.api.nvim_set_keymap("n", "<leader>gr", '<cmd>lua require"gitsigns".reset_hunk()<CR>', mapopts)
    vim.api.nvim_set_keymap("n", "<leader>gp", '<cmd>lua require"gitsigns".preview_hunk()<CR>', mapopts)
    vim.api.nvim_set_keymap("n", "<leader>gu", '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>', mapopts)

    vim.api.nvim_set_keymap("o", "ah", '<cmd>lua require"gitsigns".select_hunk()<CR>', mapopts)
    vim.api.nvim_set_keymap("v", "ah", '<cmd>lua require"gitsigns".select_hunk()<CR>', mapopts)
end

return M
