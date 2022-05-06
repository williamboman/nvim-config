local ok, iswap = pcall(require, "iswap")
if not ok then
    return
end

iswap.setup {}

vim.keymap.set("n", "<leader>s", function ()
    iswap.iswap_with()
end)
