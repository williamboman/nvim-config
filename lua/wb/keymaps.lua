vim.api.nvim_set_keymap('n',  ']q',                '<cmd>cnext<CR>',      {noremap=true})
vim.api.nvim_set_keymap('n',  '[q',                '<cmd>cprev<CR>',      {noremap=true})
vim.api.nvim_set_keymap('n',  ']Q',                '<cmd>lnext<CR>',      {noremap=true})
vim.api.nvim_set_keymap('n',  '[Q',                '<cmd>lprev<CR>',      {noremap=true})
vim.api.nvim_set_keymap('n',  '<Tab>',             '<cmd>cnext<CR>',      {noremap=true}) -- trying this out
vim.api.nvim_set_keymap('n',  '<S-Tab>',           '<cmd>cprev<CR>',      {noremap=true}) -- trying this out
vim.api.nvim_set_keymap('n',  '<leader><leader>',  '<cmd>up<CR>',         {noremap=true})
vim.api.nvim_set_keymap('n',  '<leader>.',         '<cmd>q<CR>',          {noremap=true})
vim.api.nvim_set_keymap('n',  '<C-w>e',            '<cmd>tab split<CR>',  {noremap=true})
vim.api.nvim_set_keymap('v',  '<',                 '<gv',                 {})
vim.api.nvim_set_keymap('v',  '>',                 '>gv',                 {})

--i want to be able to leave terminal yes pls
vim.api.nvim_set_keymap('t',  '<Esc>',             '<C-\\><C-n>',         {noremap=true})
