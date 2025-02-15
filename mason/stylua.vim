function! s:format()
    let save_pos = getcurpos()
    silent %!stylua -
    if v:shell_error
        echoerr "Stylua formatting failed: " . v:shell_error
        silent undo
    endif
    silent call setpos(".", save_pos)
endfunction

augroup StyluaFormat
    autocmd!
    autocmd FileType lua nnoremap <buffer> <silent> <leader>p <cmd>call <sid>format()<cr>
augroup END
