nnoremap ]q <cmd>cnext<CR>
nnoremap [q <cmd>cprev<CR>
nnoremap ]Q <cmd>lnext<CR>
nnoremap [Q <cmd>lprev<CR>
nnoremap <leader><leader> <cmd>up<CR>
nnoremap <leader>. <cmd>q<CR>
nnoremap <C-w>e <cmd>tab split<CR>

" i want to be able to leave terminal yes pls
tnoremap <Esc> <C-\><C-n>

nnoremap Y y$
nnoremap J mzJ`z

inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv
nnoremap <C-j> <esc>:m .+1<CR>==
nnoremap <C-k> <esc>:m .-2<CR>==
