require('wb.plugins')
require('wb.settings')

require('wb.keymaps')

require('wb.lsp').setup()

vim.cmd([[
    if argc() == 0 && !exists("s:std_in") | :intro | endif
]])

vim.cmd([[
    command! PrintLocationRef :echo join([expand('%'), line('.'), col('.')], ':')
]])
