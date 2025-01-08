nnoremap <BS> :
vnoremap <BS> :
nnoremap <Esc> :nohl<cr>

" Buffers
nnoremap <C-Space> <C-^>

" Diagnostics
nnoremap 9d <cmd>lua vim.diagnostic.jump { count = 1, float = true }<cr>
nnoremap 8d <cmd>lua vim.diagnostic.jump { count = -1, float = true }<cr>
nnoremap 9e <cmd>lua vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR, float = true }<cr>
nnoremap 8e <cmd>lua vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR, float = true }<cr>
nnoremap 9. <cmd>lua vim.diagnostic.open_float()<cr>
