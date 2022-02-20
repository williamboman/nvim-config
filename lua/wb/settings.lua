vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0
vim.g.nvcode_termcolors = 256
vim.o.termguicolors = true
vim.g.mapleader = ","
vim.cmd [[syntax on]]
vim.o.clipboard = "unnamedplus"
vim.o.hlsearch = true
vim.o.hidden = true
vim.o.updatetime = 500
vim.o.scrolloff = 5
vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath "cache" .. "/undo"
vim.o.inccommand = "split"
vim.o.laststatus = 2
vim.o.cmdheight = 2
vim.o.splitbelow = true
vim.o.splitright = true
vim.wo.signcolumn = "yes"
vim.wo.number = true
vim.wo.wrap = true
vim.wo.cursorline = true
vim.wo.relativenumber = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.mouse = "a"
vim.o.errorbells = false
vim.o.title = true
vim.o.ruler = true
vim.o.showcmd = true
vim.o.startofline = false
vim.o.backspace = "indent,eol,start"
vim.o.diffopt = "filler,vertical"
vim.o.wildmenu = true
vim.cmd [[ set formatoptions-=t formatoptions-=o ]]
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"

if vim.fn.has "win32" == 1 then
    vim.o.shell = "powershell.exe"
end

vim.diagnostic.config {
    float = {
        header = false,
        source = "always",
    },
}
