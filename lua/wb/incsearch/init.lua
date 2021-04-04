local M = {}

M.setup = function ()
    vim.g['incsearch#auto_nohlsearch'] = 1

    vim.api.nvim_set_keymap('', '/',  '<Plug>(incsearch-forward)',  {})
    vim.api.nvim_set_keymap('', '?',  '<Plug>(incsearch-backward)', {})
    vim.api.nvim_set_keymap('', 'g/', '<Plug>(incsearch-stay)',     {})
    vim.api.nvim_set_keymap('', 'n',  '<Plug>(incsearch-nohl-n)',   {})
    vim.api.nvim_set_keymap('', 'N',  '<Plug>(incsearch-nohl-N)',   {})
    vim.api.nvim_set_keymap('', '*',  '<Plug>(incsearch-nohl-*)',   {})
    vim.api.nvim_set_keymap('', '#',  '<Plug>(incsearch-nohl-#)',   {})
    vim.api.nvim_set_keymap('', 'g*', '<Plug>(incsearch-nohl-g*)',  {})
    vim.api.nvim_set_keymap('', 'g#', '<Plug>(incsearch-nohl-g#)',  {})
end

return M
