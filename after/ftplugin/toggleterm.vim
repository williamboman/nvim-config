function! s:set_opts() abort
    setlocal winhighlight+=,CursorLineSign:DarkenedPanel
endfunction

autocmd! TermEnter <buffer> ++once call s:set_opts()
