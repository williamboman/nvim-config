function! s:bonly() abort
    let buf = bufnr("%")
    exe 'bufdo if bufnr("%") != ' . l:buf . ' | bd | endif'
endfunction

command! Bonly call s:bonly()
