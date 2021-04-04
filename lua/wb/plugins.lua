local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer-lib/opt/packer.nvim'

local function install_packer()
    execute('!git clone https://github.com/wbthomason/packer.nvim "' .. install_path .. '"')
end

if fn.empty(fn.glob(install_path)) > 0 then
    install_packer()
end

vim.cmd [[packadd packer.nvim]]

function _G.packer_upgrade()
    execute('!rm -rf "' .. install_path .. '"')
    install_packer()
end

vim.cmd([[
command! PackerUpgrade :call v:lua.packer_upgrade()
]])

return require('packer').startup(function(use, use_rocks)
    -- tpope
    use {
        'tpope/vim-repeat',
        'tpope/vim-commentary',
        'tpope/vim-surround',
        'tpope/vim-sleuth',
        'tpope/vim-fugitive',
        { 'tpope/vim-dispatch',
            requires = {'radenling/vim-dispatch-neovim'} },
    }

    -- test & debugging
    use {
        { 'puremourning/vimspector',
            setup = function ()
                vim.fn.sign_define('vimspectorBP', {text=' ●', texthl='VimspectorBreakpoint'})
                vim.fn.sign_define('vimspectorBPCond', {text=' ●', texthl='VimspectorBreakpointCond'})
                vim.fn.sign_define('vimspectorBPDisabled', {text=' ●', texthl='VimspectorBreakpointDisabled'})
                vim.fn.sign_define('vimspectorPC', {text='▶', texthl='VimspectorProgramCounter', linehl='VimspectorProgramCounterLine'})
                vim.fn.sign_define('vimspectorPCBP', {text='●▶', texthl='VimspectorProgramCounterBreakpoint', linehl='VimspectorProgramCounterLine'})
            end,
            ft = {'javascript', 'javascriptreact', 'typescript', 'typescriptreact'} },
        { 'janko/vim-test',
            config = function ()
                require'wb.vim-test'.setup()
            end },
    }

    use {
        'kkoomen/vim-doge',
        cmd = {'DogeGenerate'},
        run = function() fn['doge#install']() end,
        setup = function ()
            vim.g.doge_enable_mappings = 0
            vim.g.doge_comment_jump_modes = {'n'}
        end
    }

    -- nvim extensions & decorators
    use {
        'simnalamburt/vim-mundo',
        'airblade/vim-rooter',
        'hrsh7th/vim-vsnip',
        'Raimondi/delimitMate',
        'wellle/tmux-complete.vim',
        { 'hrsh7th/nvim-compe',
            config = function ()
                require 'wb.nvim-compe'.setup()
            end },
        { 'rhysd/clever-f.vim',
            setup = function ()
                vim.g.clever_f_across_no_line = 1
            end },
        { 'matze/vim-move',
            setup = function ()
                vim.g.move_key_modifier = 'C'
            end },
        'psliwka/vim-smoothie',
        { 'junegunn/vim-peekaboo',
            setup = function ()
                vim.g.peekaboo_compact = 0
            end },
        { 'williamboman/nvim-tree.lua',
            branch = 'event-api',
            config = function ()
                require 'wb.nvim-tree'.setup()
            end },
        { 'glepnir/galaxyline.nvim',
            branch = 'main',
            config = function ()
                require 'wb.galaxyline'.setup()
            end },
        { 'szw/vim-maximizer',
            config = function ()
                vim.api.nvim_set_keymap('n', '<C-w>z', '<cmd>MaximizerToggle!<CR>', {silent=true, noremap=false})
            end },
        { 'voldikss/vim-floaterm',
            config = function ()
                vim.api.nvim_set_keymap('n', '<C-t>', '<cmd>FloatermToggle<CR>', { noremap = true })
                vim.api.nvim_set_keymap('t', '<C-t>', '<C-\\><C-n><cmd>FloatermToggle<CR>', { noremap = true })
            end },
        { 'haya14busa/incsearch.vim',
            config = function ()
                require'wb.incsearch'.setup()
            end },
    }

    -- UI & Syntax
    use {
        'editorconfig/editorconfig-vim',
        'sheerun/vim-polyglot',
        'christianchiarulli/nvcode-color-schemes.vim',
        'kyazdani42/nvim-web-devicons',
        -- { 'lukas-reineke/indent-blankline.nvim',
        --     branch = 'lua',
        --     setup = function ()
        --         vim.g.indent_blankline_use_treesitter = true
        --         vim.g.indent_blankline_buftype_exclude = {'terminal', 'nofile', }
        --         vim.g.indent_blankline_filetype_exclude = {'help', 'packer', }
        --         vim.g.indent_blankline_char = '▏'
        --         vim.cmd([[set colorcolumn=99999]]) -- fix indentline for now
        --     end,
        -- },
        { 'norcalli/nvim-colorizer.lua', config = function ()
            require 'wb.nvim-colorizer'.setup()
        end },
    }

    -- Treesitter
    use {
        'nvim-treesitter/playground',
        'p00f/nvim-ts-rainbow',
        'JoosepAlviste/nvim-ts-context-commentstring',
        'nvim-treesitter/nvim-treesitter-textobjects',
        { 'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate',
            config = function ()
                require 'wb.nvim-treesitter'.setup()
            end
        },
        { 'windwp/nvim-ts-autotag',
            ft = { 'html', 'javascript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue' } },
    }

    -- LSP
    use {
        'neovim/nvim-lspconfig',
        { 'williamboman/nvim-lsp-installer', branch = 'main' },
        { 'mfussenegger/nvim-jdtls', ft = { 'java' } },
        { 'onsails/lspkind-nvim',
            config = function ()
                require'lspkind'.init()
            end },
    }

    -- Telescope
    use {
        'williamboman/telescope.nvim',
        branch = 'show-client-in-lsp-code-actions',
        requires = {
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
        },
        config = function ()
            require 'wb.telescope'.setup()
        end,
        -- 'nvim-telescope/telescope-fzy-native.nvim',
        -- 'nvim-telescope/telescope-media-files.nvim',
    }

    -- git
    use {
        'rhysd/git-messenger.vim',
        { 'lewis6991/gitsigns.nvim',
            requires = {
                'nvim-lua/plenary.nvim'
            },
            config = function ()
                require'wb.gitsigns'.setup()
            end },
    }

    -- Misc
    use { 'tweekmonster/startuptime.vim', cmd = {'StartupTime'} }
    use 'wakatime/vim-wakatime'
end)
