local M = {}
local devicons = require "nvim-web-devicons"

local expand = vim.fn.expand

function M.winbar()
    local icon = devicons.get_icon(expand "%", expand "%:e", { default = true })
    local actual_curwin = tonumber(vim.g.actual_curwin)
    local curwin = vim.api.nvim_get_current_win()
    if actual_curwin == curwin then
        return "%#WinBarActive#%#WinBarTextActive#" .. icon .. " %f%m%r%#WinBarActive#"
    else
        return "%#WinBarInactive#%#WinBarTextInactive#" .. icon .. " %f%m%r%#WinBarInactive#"
    end
end

return M
