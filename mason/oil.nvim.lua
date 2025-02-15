local deferred = defer(function()
    vim.cmd.packadd("oil.nvim")
    require("oil").setup({
        keymaps = {
            ["<C-s>"] = {
                "actions.select",
                opts = { horizontal = true },
                desc = "Open the entry in a horizontal split",
            },
            ["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
        },
    })
end)

deferred.keymap("n", "<leader>a", vim.cmd.Oil)
