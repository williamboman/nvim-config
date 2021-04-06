augroup sleuthcompat
    autocmd!
    autocmd FileType * if len(findfile('.editorconfig', '.;')) == 0 | Sleuth | endif
augroup END
