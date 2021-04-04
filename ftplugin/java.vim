lua require'jdtls'.start_or_attach({cmd = {'java-lsp.sh'}})
" The following doesn't seem to work?
lua require'wb.lsp.keymaps'.buf_set_keymaps(bufnr('%'), 'jdtls')
