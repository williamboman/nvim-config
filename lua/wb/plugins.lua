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
        "vim-test/vim-test",
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
    }

    -- things that either enhance builtin behaviours or could easily be candidates for default behaviour
    use {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        "https://github.com/vigoux/notifier.nvim",
        "lewis6991/hover.nvim",
        "lewis6991/satellite.nvim",
        "stevearc/aerial.nvim",
        "ggandor/leap.nvim",
        "simnalamburt/vim-mundo",
        "airblade/vim-rooter",
        "stevearc/dressing.nvim",
        "linty-org/readline.nvim",
        "akinsho/toggleterm.nvim",
        "nvim-lualine/lualine.nvim",
        "numToStr/Comment.nvim",
        "windwp/nvim-autopairs",
        "szw/vim-maximizer",
        "zbirenbaum/neodim",
        { "s1n7ax/nvim-window-picker", tag = "v1.*" },
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
                "onsails/lspkind-nvim",
                {
                    "L3MON4D3/LuaSnip",
                    requires = { "rafamadriz/friendly-snippets" },
                },
            },
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
        },
        {
            "editorconfig/editorconfig-vim",
            setup = function()
                vim.g.EditorConfig_max_line_indicator = ""
                vim.g.EditorConfig_preserve_formatoptions = 1
            end,
        },
    }

    -- UI
    use {
        "projekt0n/github-nvim-theme",
        "rebelot/kanagawa.nvim",
        "kyazdani42/nvim-web-devicons",
        "lukas-reineke/headlines.nvim",
        "lukas-reineke/indent-blankline.nvim",
        "norcalli/nvim-colorizer.lua",
    }

    -- Treesitter
    if vim.fn.has "unix" == 1 then
        use {
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
            requires = {
                "nvim-treesitter/playground",
                "nvim-treesitter/nvim-treesitter-textobjects",
                "p00f/nvim-ts-rainbow",
                "JoosepAlviste/nvim-ts-context-commentstring",
                "windwp/nvim-ts-autotag",
            },
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
        "lvimuser/lsp-inlayhints.nvim",
        "SmiteshP/nvim-navic",
    }

    -- Telescope
    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-project.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
        },
    }

    -- git
    use {
        "rhysd/git-messenger.vim",
        "rhysd/committia.vim",
        "ruifm/gitlinker.nvim",
        "lewis6991/gitsigns.nvim",
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
