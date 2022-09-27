local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
    return
end

gitsigns.setup {
    keymaps = {},
    current_line_blame = false,
    current_line_blame_opts = {
        delay = vim.o.updatetime,
    },
}

vim.keymap.set("n", "]c", gitsigns.next_hunk)
vim.keymap.set("n", "[c", gitsigns.prev_hunk)

vim.keymap.set("n", "<leader>ga", gitsigns.stage_hunk)
vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk)
vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk)
vim.keymap.set("n", "<leader>gu", gitsigns.undo_stage_hunk)

vim.keymap.set("o", "ah", gitsigns.select_hunk)
vim.keymap.set("v", "ah", gitsigns.select_hunk)
