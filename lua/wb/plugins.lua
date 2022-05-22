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
            "github/copilot.vim",
            setup = function()
                vim.g.copilot_filetypes = {
                    ["TelescopePrompt"] = false,
                    ["DressingInput"] = false,
                }
            end,
        },
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

    use {
        "kkoomen/vim-doge",
        cmd = { "DogeGenerate" },
        run = function()
            vim.fn["doge#install"]()
        end,
        setup = function()
            vim.g.doge_enable_mappings = 0
            vim.g.doge_comment_jump_modes = { "n" }
        end,
    }

    -- nvim extensions & decorators
    use {
        "ggandor/lightspeed.nvim",
        "simnalamburt/vim-mundo",
        "airblade/vim-rooter",
        "mizlan/iswap.nvim",
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
            "ms-jpq/coq_nvim",
            requires = {
                { "ms-jpq/coq.artifacts", branch = "artifacts" },
                { "ms-jpq/coq.thirdparty", branch = "3p" },
                {
                    "onsails/lspkind-nvim",
                    config = function()
                        require("lspkind").init()
                    end,
                },
            },
            branch = "coq",
            setup = function()
                vim.g.coq_settings = {
                    keymap = { recommended = false }, -- for autopairs
                    auto_start = "shut-up",
                    ["display.pum.fast_close"] = false,
                }
            end,
            config = function()
                require("wb.coq_nvim").setup()
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
            requires = {
                "arkav/lualine-lsp-progress",
                {
                    "SmiteshP/nvim-gps",
                    config = function()
                        require("nvim-gps").setup()
                    end,
                },
            },
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
                vim.cmd [[autocmd TermEnter term://*toggleterm#* tnoremap <buffer> <C-t> <Esc><Cmd>ToggleTerm<CR>]]
                vim.cmd [[autocmd TermEnter term://*toggleterm#* nnoremap <buffer> <C-t> <Esc><Cmd>ToggleTerm<CR>]]
            end,
        },
    }

    -- UI & Syntax
    use {
        {
            "rebelot/kanagawa.nvim",
            config = function()
                require("kanagawa").setup {
                    overrides = {
                        WinSeparator = { fg = "#363646" },
                        WinBarActive = { fg = "#1F1F28", bg = "#2A2A37", style = "inverse" },
                        WinBarTextActive = { fg = "#7FB4CA", bg = "#2A2A37" },
                        WinBarInactive = { fg = "#1F1F28", bg = "#2A2A37", style = "inverse" },
                        WinBarTextInactive = { fg = "#7a7a7b", bg = "#2A2A37" },
                        Comment = { fg = "#888181" },
                        FloatTitle = { fg = "#14141A", bg = "#957FB8", style = "bold" },
                        DressingInputNormalFloat = { bg = "#14141A" },
                        DressingInputFloatBorder = { fg = "#14141A", bg = "#14141A" },
                        NeoTreeGitUntracked = { link = "NeoTreeGitModified" },
                        IndentBlanklineChar = { fg = "#2F2F40" },
                        IndentBlanklineContextStart = { style = "bold" },
                        LualineGitAdd = { link = "GitSignsAdd" },
                        LualineGitChange = { link = "GitSignsAdd" },
                        LualineGitDelete = { link = "GitSignsDelete" },
                        NeoTreeNormal = { bg = "#14141A" },
                        NeoTreeNormalNC = { bg = "#14141A" },
                        TabLine = { style = "italic", bg = "#363646" },
                        TabLineFill = { bg = "#1F1F28" },
                        TabLineSel = { style = "bold", bg = "#1F1F28" },
                        TabNum = { link = "TabLine" },
                        TabNumSel = { link = "TabLineSel" },
                        TelescopeBorder = { fg = "#1a1a22", bg = "#1a1a22" },
                        TelescopeMatching = { style = "underline", fg = "#7FB4CA", guisp = "#7FB4CA" },
                        TelescopeNormal = { bg = "#1a1a22" },
                        TelescopePreviewTitle = { fg = "#1a1a22", bg = "#7FB4CA" },
                        TelescopePromptBorder = { fg = "#2A2A37", bg = "#2A2A37" },
                        TelescopePromptNormal = { fg = "#DCD7BA", bg = "#2A2A37" },
                        TelescopePromptPrefix = { fg = "#957FB8", bg = "#2A2A37" },
                        TelescopePromptTitle = { fg = "#1a1a22", bg = "#957FB8" },
                        TelescopeResultsTitle = { fg = "#1a1a22", bg = "#1a1a22" },
                        TelescopeTitle = { style = "bold", fg = "#C8C093" },
                        Visual = { bg = "#4C566A" },
                    },
                }
                vim.cmd [[colorscheme kanagawa]]
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
            "nvim-treesitter/playground",
            "p00f/nvim-ts-rainbow",
            "JoosepAlviste/nvim-ts-context-commentstring",
            "nvim-treesitter/nvim-treesitter-textobjects",
            {
                "andymass/vim-matchup",
                config = function()
                    vim.g.matchup_matchparen_offscreen = {
                        method = "popup",
                        fullwidth = 1,
                        highlight = "OffscreenMatchPopup",
                    }
                end,
            },
            {
                "nvim-treesitter/nvim-treesitter",
                run = ":TSUpdate",
                config = function()
                    require("wb.nvim-treesitter").setup()
                end,
            },
            {
                "windwp/nvim-ts-autotag",
                ft = { "html", "javascript", "javascriptreact", "typescriptreact", "svelte", "vue" },
            },
        }
    end

    -- LSP
    local lsp_installer = vim.trim(vim.fn.system "hostname") == "Williams-MacBook-Air.local"
            and "~/dev/github/nvim-lsp-installer"
        or "williamboman/nvim-lsp-installer"
    use {
        lsp_installer,
        "neovim/nvim-lspconfig",
        "folke/lua-dev.nvim",
        "b0o/SchemaStore.nvim",
        "ray-x/lsp_signature.nvim",
        "simrat39/rust-tools.nvim",
        "jose-elias-alvarez/null-ls.nvim",
        "jose-elias-alvarez/typescript.nvim",
        "j-hui/fidget.nvim",
    }

    use {
        "narutoxy/dim.lua",
        requires = { "nvim-treesitter/nvim-treesitter", "neovim/nvim-lspconfig" },
        config = function()
            require("dim").setup {}
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
