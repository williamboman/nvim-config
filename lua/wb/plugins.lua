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
        {
            "psliwka/vim-smoothie",
            setup = function()
                -- Speed up cursor speed at the end of the animation.
                vim.g.smoothie_speed_constant_factor = 50
                -- Higher... fps?
                vim.g.smoothie_update_interval = 5
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
            "t9md/vim-choosewin",
            config = function()
                vim.api.nvim_set_keymap("n", "-", "<Plug>(choosewin)", {})
            end,
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
            "kyazdani42/nvim-tree.lua",
            setup = function()
                vim.g.nvim_tree_respect_buf_cwd = 1
                vim.g.nvim_tree_git_hl = 1
                vim.g.nvim_tree_add_trailing = 1
            end,
            config = function()
                require("wb.nvim-tree").setup()
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
                    open_mapping = [[<C-t>]],
                }
                -- Remove WinEnter to allow moving a toggleterm to new tab
                vim.cmd [[autocmd! ToggleTerminal WinEnter]]
                vim.cmd [[iunmap <C-t>]]
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
                        Comment = { fg = "#888181" },
                        DressingInputText = { bg = "none" },
                        FloatTitle = { style = "bold" },
                        IncSearch = { fg = "#B48EAD", bg = "#5C6370" },
                        IndentBlanklineChar = { fg = "#2F2F40" },
                        IndentBlanklineContextStart = { style = "bold" },
                        LualineGitAdd = { link = "GitSignsAdd" },
                        LualineGitChange = { link = "GitSignsAdd" },
                        LualineGitDelete = { link = "GitSignsDelete" },
                        NvimTreeNormal = { bg = "#14141A" },
                        Search = { fg = "#232731", bg = "#B48EAD" },
                        TabLine = { style = "italic", bg = "#363646" },
                        TabLineFill = { bg = "#1F1F28" },
                        TabLineSel = { style = "bold", bg = "#1F1F28" },
                        TabNum = { link = "TabLine" },
                        TabNumSel = { link = "TabLineSel" },
                        TelescopeMatching = { style = "underline", fg = "#7FB4CA", guisp = "#7FB4CA" },
                        TelescopeTitle = { style = "bold", fg = "#C8C093" },
                        Visual = { bg = "#4C566A" },
                    },
                }
                vim.cmd [[colorscheme kanagawa]]
            end,
        },
        "editorconfig/editorconfig-vim",
        {
            "stevearc/dressing.nvim",
            config = function()
                require("dressing").setup {
                    input = {
                        winhighlight = "NormalFloat:DressingInputNormalFloat",
                    },
                }
            end,
        },
        {
            "sheerun/vim-polyglot",
            setup = function()
                vim.g.polyglot_disabled = { "autoindent", "sensible" }
                vim.g.polyglot_disabled = { "markdown" }
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
        requires = {
            "neovim/nvim-lspconfig",
            "folke/lua-dev.nvim",
            "b0o/SchemaStore.nvim",
            "ray-x/lsp_signature.nvim",
            "simrat39/rust-tools.nvim",
            "jose-elias-alvarez/null-ls.nvim",
            "jose-elias-alvarez/nvim-lsp-ts-utils",
            "j-hui/fidget.nvim",
        },
        after = "coq_nvim",
        config = function()
            require("wb.lsp").setup()
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
    if vim.fn.has "win32" ~= 1 then
        use "wakatime/vim-wakatime"
    end
end

require("packer").startup {
    spec,
    config = {
        display = {
            open_fn = require("packer.util").float,
        },
    },
}
