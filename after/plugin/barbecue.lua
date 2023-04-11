local ok, barbecue = pcall(require, "barbecue")
if not ok then
    return
end

barbecue.setup {
    show_modified = true,
    symbols = {
        modified = "[+]"
    },
    custom_section = function ()
        local sw = vim.o.sw
        local et = vim.o.et and "et" or "noet"
        local tw = vim.o.tw
        local curwin = vim.api.nvim_get_current_win()
        local hl = "WinBarActiveMuted"

        local buf_name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(curwin))

        local text_settings = ("%%=%%#%s#sw=%s %s tw=%s "):format(hl, sw, et, tw)

        if buf_name == "" then
            return "[A Buffer Has No Name]" .. text_settings
        else
            return text_settings
        end
    end
}
