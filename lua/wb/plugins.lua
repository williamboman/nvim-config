local install_path = ("%s/site/pack/packer-lib/opt/packer.nvim"):format(vim.fn.stdpath "data")

local function install_packer()
    vim.fn.termopen(("git clone https://github.com/wbthomason/packer.nvim %q"):format(install_path))
end

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    install_packer()
end

vim.cmd [[packadd packer.nvim]]

function _G.packer_upgrade()
    vim.fn.delete(install_path, "rf")
    install_packer()
end

vim.cmd [[command! PackerUpgrade :call v:lua.packer_upgrade()]]

local function spec(use)
    use { "lewis6991/impatient.nvim" }

    -- tpope
    use {
        "tpope/vim-repeat",
        "tpope/vim-surround",
        "tpope/vim-fugitive",
        "tpope/vim-unimpaired",
        {
            "tpope/vim-sleuth",
            setup = function()
                vim.g.sleuth_automatic = 0
            end,
        },
        {
            "tpope/vim-dispatch",
            requires = { "radenling/vim-dispatch-neovim" },
        },
    }

    -- test & debugging
    use {
        {
            "puremourning/vimspector",
            setup = function()
                vim.fn.sign_define("vimspectorBP", { text = " ●", texthl = "VimspectorBreakpoint" })
                vim.fn.sign_define("vimspectorBPCond", { text = " ●", texthl = "VimspectorBreakpointCond" })
                vim.fn.sign_define("vimspectorBPDisabled", { text = " ●", texthl = "VimspectorBreakpointDisabled" })
                vim.fn.sign_define(
                    "vimspectorPC",
                    { text = "▶", texthl = "VimspectorProgramCounter", linehl = "VimspectorProgramCounterLine" }
                )
                vim.fn.sign_define("vimspectorPCBP", {
                    text = "●▶",
                    texthl = "VimspectorProgramCounterBreakpoint",
                    linehl = "VimspectorProgramCounterLine",
                })
            end,
            ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        },
        {
            "janko/vim-test",
            config = function()
                require("wb.vim-test").setup()
            end,
        },
    }

    -- things that either enhance builtin behaviours or could easily be candidates for default behaviour
    use {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        "lewis6991/satellite.nvim",
        "ggandor/leap.nvim",
        "simnalamburt/vim-mundo",
        "airblade/vim-rooter",
        "mizlan/iswap.nvim",
        "linty-org/readline.nvim",
        {
            "andymass/vim-matchup",
            setup = function()
                vim.g.matchup_matchparen_offscreen = {
                    method = "popup",
                    fullwidth = 1,
                    highlight = "OffscreenMatchPopup",
                }
            end,
        },
        {
            "numToStr/Comment.nvim",
            config = function()
                require("Comment").setup()
            end,
        },
        {
            "windwp/nvim-autopairs",
            config = function()
                require("wb.nvim-autopairs").setup()
            end,
        },
        {
            "s1n7ax/nvim-window-picker",
            tag = "v1.*",
        },
        {
            -- "hrsh7th/nvim-cmp",
            "williamboman/nvim-cmp",
            branch = "feat/docs-preview-window",
            requires = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-calc",
                "hrsh7th/cmp-path",
                "andersevenrud/cmp-tmux",
                "saadparwaiz1/cmp_luasnip",
                "petertriho/cmp-git",
                {
                    "L3MON4D3/LuaSnip",
                    requires = { "rafamadriz/friendly-snippets" },
                    config = function()
                        require("luasnip.loaders.from_vscode").lazy_load()
                    end,
                },
                {
                    "onsails/lspkind-nvim",
                    config = function()
                        require("lspkind").init()
                    end,
                },
            },
            config = function()
                require("wb.cmp").setup()
            end,
        },
        {
            "junegunn/vim-peekaboo",
            setup = function()
                vim.g.peekaboo_compact = 0
            end,
        },
        {
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v2.x",
            requires = {
                "nvim-lua/plenary.nvim",
                "kyazdani42/nvim-web-devicons",
                "MunifTanjim/nui.nvim",
            },
            config = function()
                require("wb.neo-tree").setup()
            end,
        },
        {
            "nvim-lualine/lualine.nvim",
            config = function()
                require("wb.lualine").setup()
            end,
        },
        {
            "szw/vim-maximizer",
            config = function()
                vim.api.nvim_set_keymap("n", "<C-w>z", "<cmd>MaximizerToggle!<CR>", { silent = true, noremap = false })
            end,
        },
        {
            "akinsho/toggleterm.nvim",
            config = function()
                require("toggleterm").setup {
                    insert_mappings = false,
                    env = {
                        MANPAGER = "less -X",
                    },
                    terminal_mappings = false,
                    start_in_insert = false,
                    open_mapping = [[<space>t]],
                    highlights = {
                        CursorLineSign = { link = "DarkenedPanel" },
                        Normal = { guibg = "#14141A" },
                    },
                }

                -- Remove WinEnter to allow moving a toggleterm to new tab
                vim.cmd [[autocmd! ToggleTermCommands WinEnter]]
            end,
        },
        {
            "editorconfig/editorconfig-vim",
            setup = function()
                vim.g.EditorConfig_max_line_indicator = ""
                vim.g.EditorConfig_preserve_formatoptions = 1
            end,
        },
        {
            "stevearc/dressing.nvim",
            config = function()
                require("dressing").setup {
                    input = {
                        winblend = 10,
                        winhighlight = "Normal:DressingInputNormalFloat,NormalFloat:DressingInputNormalFloat,FloatBorder:DressingInputFloatBorder",
                        border = "single",
                    },
                }
            end,
        },
    }

    -- UI
    use {
        "projekt0n/github-nvim-theme",
        {
            "rebelot/kanagawa.nvim",
            commit = "a6db77965a27ca893ea693d69cc3c152c000a627",
        },
        "christianchiarulli/nvcode-color-schemes.vim",
        "kyazdani42/nvim-web-devicons",
        {
            "lukas-reineke/indent-blankline.nvim",
            setup = function()
                vim.g.indent_blankline_use_treesitter = true
                vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
                vim.g.indent_blankline_filetype_exclude = { "help", "packer" }
                vim.g.indent_blankline_char = "▏"
                vim.cmd [[set colorcolumn=99999]]
            end,
            config = function()
                require("indent_blankline").setup {
                    show_current_context = true,
                    show_current_context_start = true,
                }
            end,
        },
        {
            "norcalli/nvim-colorizer.lua",
            config = function()
                require("wb.nvim-colorizer").setup()
            end,
        },
    }

    -- Treesitter
    if vim.fn.has "unix" == 1 then
        use {
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
            requires = {
                "nvim-treesitter/playground",
                "nvim-treesitter/nvim-treesitter-context",
                "nvim-treesitter/nvim-treesitter-textobjects",
                "p00f/nvim-ts-rainbow",
                "JoosepAlviste/nvim-ts-context-commentstring",
                "windwp/nvim-ts-autotag",
            },
            config = function()
                require("wb.nvim-treesitter").setup()
            end,
        }
    end

    local is_macbook = vim.trim(vim.fn.system "hostname") == "Williams-MacBook-Air.local"

    -- LSP
    local mason = is_macbook and "~/dev/github/mason.nvim" or "williamboman/mason.nvim"
    local mason_lspconfig = is_macbook and "~/dev/github/mason-lspconfig.nvim" or "williamboman/mason-lspconfig.nvim"
    use {
        mason,
        mason_lspconfig,
        "neovim/nvim-lspconfig",
        "folke/lua-dev.nvim",
        "b0o/SchemaStore.nvim",
        "ray-x/lsp_signature.nvim",
        { "simrat39/rust-tools.nvim", branch = "modularize_and_inlay_rewrite" },
        "jose-elias-alvarez/null-ls.nvim",
        "jose-elias-alvarez/typescript.nvim",
        "j-hui/fidget.nvim",
    }

    use {
        "zbirenbaum/neodim",
        requires = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("neodim").setup {
                alpha = 0.6,
                hide = {
                    virtual_text = false,
                    signs = true,
                    underline = false,
                },
            }
        end,
    }

    use {
        "rmagatti/goto-preview",
        config = function()
            require("goto-preview").setup {
                default_mappings = true,
                opacity = 7,
                post_open_hook = function(buf_handle, win_handle)
                    vim.cmd(([[ autocmd WinLeave <buffer> ++once call nvim_win_close(%d, v:false)]]):format(win_handle))
                    vim.api.nvim_buf_set_keymap(
                        buf_handle,
                        "n",
                        "<Esc>",
                        ("<cmd>call nvim_win_close(%d, v:false)<CR>"):format(win_handle),
                        { noremap = true }
                    )
                end,
            }
        end,
    }

    -- Telescope
    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-project.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
        },
        config = function()
            require("wb.telescope").setup()
        end,
    }

    -- git
    use {
        "rhysd/git-messenger.vim",
        "rhysd/committia.vim",
        {
            "ruifm/gitlinker.nvim",
            config = function()
                require("gitlinker").setup()

                vim.api.nvim_set_keymap(
                    "n",
                    "<leader>go",
                    '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<CR>',
                    { silent = true }
                )
                vim.api.nvim_set_keymap(
                    "v",
                    "<leader>go",
                    '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<CR>',
                    { silent = true }
                )
            end,
        },
        {
            "lewis6991/gitsigns.nvim",
            requires = {
                "nvim-lua/plenary.nvim",
            },
            config = function()
                require("wb.gitsigns").setup()
            end,
        },
    }

    -- Misc
    use { "tweekmonster/startuptime.vim", cmd = { "StartupTime" } }
    use "wakatime/vim-wakatime"
end

require("packer").startup {
    spec,
    config = {
        display = {
            open_fn = require("packer.util").float,
        },
        max_jobs = vim.fn.has "win32" == 1 and 5 or nil,
    },
}
