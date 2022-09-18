local ok, dialmap = pcall(require, "dial.map")
if not ok then
    return
end

local augend = require "dial.augend"
require("dial.config").augends:register_group {
    default = {
        augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
        augend.constant.alias.bool, -- boolean value (true <-> false)
        augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
        augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
    },
}

vim.keymap.set("n", "<C-a>", dialmap.inc_normal())
vim.keymap.set("n", "<C-x>", dialmap.dec_normal())
vim.keymap.set("v", "<C-a>", dialmap.inc_visual())
vim.keymap.set("v", "<C-x>", dialmap.dec_visual())
vim.keymap.set("v", "g<C-a>", dialmap.inc_gvisual())
vim.keymap.set("v", "g<C-x>", dialmap.dec_gvisual())
