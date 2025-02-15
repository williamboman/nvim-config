local deferred = defer(function()
    vim.cmd.packadd("plenary.nvim")
    vim.cmd.packadd("telescope.nvim")
    vim.cmd.packadd("telescope-fzf-native.nvim")

    local actions = require("telescope.actions")
    local layout_actions = require("telescope.actions.layout")

    require("telescope").setup({
        defaults = {
            prompt_prefix = "  ",
            selection_caret = "  ",
            selection_strategy = "reset",
            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
                "--hidden",
                "--glob=!.git/",
            },
            sorting_strategy = "descending",
            layout_strategy = "flex",
            layout_config = {
                flex = {
                    flip_columns = 161, -- half 27" monitor, scientifically calculated
                },
                horizontal = {
                    preview_width = 0.4,
                },
                vertical = {
                    preview_cutoff = 43, -- height of 13" monitor, scentifically measured
                    preview_height = 0.4,
                },
            },
            path_display = { truncate = 3 },
            color_devicons = true,
            winblend = 5,
            set_env = { ["COLORTERM"] = "truecolor" },
            border = {},
            borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
            mappings = {
                i = {
                    ["<C-w>"] = function()
                        vim.api.nvim_input("<c-s-w>")
                    end,
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-p>"] = actions.cycle_history_prev,
                    ["<C-n>"] = actions.cycle_history_next,
                    ["<C-l>"] = layout_actions.toggle_preview,
                    ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                    ["<C-s>"] = actions.select_horizontal,
                    ["<Esc>"] = actions.close,
                    ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
                    ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
                },
            },
        },
        extensions = {
            project = {
                hidden_files = false,
            },
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            },
        },
    })

    require("telescope").load_extension("fzf")
end)

local builtin = deferred.require("telescope.builtin")

local function grep(opts)
    opts = opts or {}
    local search = vim.fn.input("Grep >")
    if search ~= "" then
        builtin.grep_string({
            cwd = opts.cwd,
            only_sort_text = true,
            search = search,
            use_regex = true,
            disable_coordinates = true,
            layout_strategy = "vertical",
            layout_config = {
                prompt_position = "top",
                mirror = true,
                preview_cutoff = 0,
                preview_height = 0.2,
            },
        })
    else
        builtin.live_grep({
            cwd = opts.cwd,
            layout_strategy = "vertical",
            layout_config = {
                prompt_position = "top",
                mirror = true,
                preview_cutoff = 0,
                preview_height = 0.2,
            },
        })
    end
end

deferred.keymap("n", "<space>p", builtin.git_files)
deferred.keymap("n", "<C-p>r", builtin.resume)
deferred.keymap("n", "<C-p>f", builtin.find_files)
deferred.keymap("n", "<C-p>.f", function()
    builtin.find_files({ cwd = vim.fn.expand("%:p:h") })
end)
deferred.keymap("n", "<C-p>q", grep)
deferred.keymap("n", "<C-p><C-q>", grep)
deferred.keymap("n", "<C-p>.q", function()
    grep({ cwd = vim.fn.expand("%:p:h") })
end)
deferred.keymap("n", "<C-p>b", builtin.buffers)
deferred.keymap("n", "<C-p>h", builtin.oldfiles)
deferred.keymap("n", "<C-p>s", function()
    builtin.git_status({
        layout_strategy = "flex",
        layout_config = {
            flex = {
                flip_columns = 161, -- half 27" monitor, scientifically calculated
            },
            horizontal = {
                preview_cutoff = 0,
                preview_width = 0.6,
            },
            vertical = {
                preview_cutoff = 0,
                preview_height = 0.65,
            },
        },
    })
end)
