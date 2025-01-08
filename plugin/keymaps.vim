nnoremap <BS> :
vnoremap <BS> :
nnoremap <Esc> :nohl<cr>

" Buffers
nnoremap <C-Space> <C-^>

" Diagnostics
nnoremap 9d :lua vim.diagnostic.jump { count = 1 }<cr>
nnoremap 8d :lua vim.diagnostic.jump { count = -1 }<cr>
nnoremap 9e :lua vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR }<cr>
nnoremap 8e :lua vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR }<cr>
