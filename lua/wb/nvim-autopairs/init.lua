local M = {}

function M.setup()
    local npairs = require "nvim-autopairs"
    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
    local cmp = require "cmp"

    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
    npairs.setup { check_ts = true, fast_wrap = {} }
end

return M
