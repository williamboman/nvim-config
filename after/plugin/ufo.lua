local ok, ufo = pcall(require, "ufo")
if not ok then
    return
end

vim.keymap.set('n', 'zR', ufo.openAllFolds)
vim.keymap.set('n', 'zM', ufo.closeAllFolds)

ufo.setup()
