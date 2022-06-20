nnoremap ]q <cmd>cnext<CR>
nnoremap [q <cmd>cprev<CR>
nnoremap ]Q <cmd>lnext<CR>
nnoremap [Q <cmd>lprev<CR>
nnoremap <C-w>e <cmd>tab split<CR>
nnoremap <C-q> <cmd>bd<CR>

" i want to be able to leave terminal yes pls
tnoremap <Esc> <C-\><C-n>

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

nnoremap <A-Up> :resize -2<CR>
nnoremap <A-Right> :vertical resize +2<CR>
nnoremap <A-Down> :resize +2<CR>
nnoremap <A-Left> :vertical resize -2<CR>

nnoremap <BS> :
vnoremap <BS> :

" search and highlight but dont jump
nnoremap * :keepjumps normal! mi*`i<CR>
nnoremap # :keepjumps normal! mi#`i<CR>

nmap <Esc> <cmd>noh<CR>

nnoremap <C-Space> <C-^>

" Use the text that has already been typed as the prefix for searching through commands
cnoremap <expr> <C-p> pumvisible() ? "<C-p>" : "<Up>"
cnoremap <expr> <C-n> pumvisible() ? "<C-n>" : "<Down>"

" keep my registers out your god damn paste
xnoremap p P

nnoremap Q "_
xnoremap Q "_
