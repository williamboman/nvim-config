vim.lsp.config("lua-language-server", {
    cmd = { "lua-language-server" },
    root_markers = { '.git' },
    filetypes = { 'lua' }
})

vim.lsp.config("yaml-language-server", {
    cmd = { 'yaml-language-server', '--stdio' },
    root_markers = { '.git' },
    filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },
})
