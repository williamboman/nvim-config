local ok, npairs = pcall(require, "nvim-autopairs")
if not ok then
    return
end
local cmp_autopairs = require "nvim-autopairs.completion.cmp"
local cmp = require "cmp"

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
npairs.setup { check_ts = true, fast_wrap = {} }
