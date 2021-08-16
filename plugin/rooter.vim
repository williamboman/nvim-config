augroup Rooter
    autocmd!
    autocmd User RooterChDir lua vim.notify(("Changed to new root.\n\n%s"):format(vim.fn.getcwd()), vim.lsp.log_levels.INFO, { title = "vim-rooter" })
augroup END
