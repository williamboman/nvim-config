augroup sleuthcompat
    autocmd!
    autocmd FileType * silent if len(findfile('.editorconfig', '.;')) == 0 | Sleuth | endif
augroup END
