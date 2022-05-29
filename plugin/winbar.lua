local devicons = require "nvim-web-devicons"

local expand, bufname = vim.fn.expand, vim.fn.bufname

function MyWinbar()
    local buffer_name = bufname()
    if #buffer_name == 0 then
        buffer_name = "[A Buffer Has No Name]"
    end
    local icon = devicons.get_icon(buffer_name, expand "%:e", { default = true })

    local actual_curwin = tonumber(vim.g.actual_curwin)
    local curwin = vim.api.nvim_get_current_win()

    local sw = vim.o.sw
    local et = vim.o.et and "et" or "noet"
    local tw = vim.o.tw
    local fo = vim.o.fo

    local text_settings = ("sw=%s %s tw=%s fo=%s "):format(sw, et, tw, fo)

    if actual_curwin == curwin then
        return "%#WinBarActive#%#WinBarTextActive#" .. icon .. " " .. buffer_name .. "%m%r%#WinBarActive#%=%#WinBarActiveMuted#" .. text_settings
    else
        return "%#WinBarInactive#%#WinBarTextInactive#" .. icon .. " " .. buffer_name .. "%m%r%#WinBarInactive#%=%#WinBarInactiveMuted#" .. text_settings
    end
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "TermOpen" }, {
    pattern = "*",
    callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
        if buftype == "" or buftype == "help" then
            vim.cmd [[setlocal winbar=%{%v:lua.MyWinbar()%}]]
        else
            vim.cmd [[setlocal winbar=]]
        end
    end,
})
