nnoremap <BS> :
vnoremap <BS> :
nnoremap <Esc> :nohl<cr>

function! s:quickfix_toggle()
    for winnr in range(1, winnr('$'))
        if getwinvar(winnr, '&syntax') == 'qf'
            cclose
            return
        endif
    endfor
    copen
endfunction

" Windows
nnoremap <Space>c <cmd>call <sid>quickfix_toggle()<cr>

" Buffers
nnoremap <C-Space> <C-^>
nnoremap <C-q> <cmd>bd<cr>

" Diagnostics
nnoremap 9d <cmd>lua vim.diagnostic.jump { count = 1, float = true }<cr>
nnoremap 8d <cmd>lua vim.diagnostic.jump { count = -1, float = true }<cr>
nnoremap 9e <cmd>lua vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR, float = true }<cr>
nnoremap 8e <cmd>lua vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR, float = true }<cr>
nnoremap 9. <cmd>lua vim.diagnostic.open_float()<cr>

tnoremap <Esc> <C-\><C-n>
tnoremap <leader><Esc> 

function! s:terminal_history()
    startinsert
    call feedkeys("\<C-p>")
endfunction
autocmd TermOpen * nnoremap <buffer><nowait> <C-p> <cmd>call <sid>terminal_history()<cr>
