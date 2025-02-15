vim.cmd.packadd("leap.nvim")
local leap = require("leap")

leap.setup({
    case_sensitive = true,
})
leap.set_default_keymaps()
