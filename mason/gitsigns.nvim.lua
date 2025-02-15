vim.cmd.packadd("gitsigns.nvim")
local gitsigns = require("gitsigns")

gitsigns.setup({
    on_attach = function(bufnr)
        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        map("n", "]c", function()
            if vim.wo.diff then
                vim.cmd.normal({ "]c", bang = true })
            else
                gitsigns.nav_hunk("next")
            end
        end)
        map("n", "9c", "]c", { remap = true })

        map("n", "[c", function()
            if vim.wo.diff then
                vim.cmd.normal({ "[c", bang = true })
            else
                gitsigns.nav_hunk("prev")
            end
        end)
        map("n", "8c", "[c", { remap = true })

        map("n", "<leader>ga", gitsigns.stage_hunk)
        map("n", "<leader>gr", gitsigns.reset_hunk)

        map("v", "<leader>ga", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end)

        map("v", "<leader>gc", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end)

        map("n", "<leader>gA", gitsigns.stage_buffer)
        map("n", "<leader>gC", gitsigns.reset_buffer)

        map("n", "<leader>gQ", function()
            gitsigns.setqflist("all")
        end)
        map("n", "<leader>gq", gitsigns.setqflist)

        map("n", "<leader>gd", gitsigns.diffthis)
        map("n", "<leader>gp", gitsigns.preview_hunk_inline)

        -- Toggles
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
        map("n", "<leader>td", gitsigns.toggle_deleted)
        map("n", "<leader>tw", gitsigns.toggle_word_diff)

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
    end,
})
