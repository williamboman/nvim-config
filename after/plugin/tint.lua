local ok, tint = pcall(require, "tint")
if not ok then
    return
end

tint.setup {
    tint = -30,
    saturation = 0.5,
    highlight_ignore_patterns = { "WinBar.*", "WinSeparator", "IndentBlankline.*", "SignColumn", "EndOfBuffer" },
    window_ignore_function = function(winid)
        -- Don't tint floating windows.
        if vim.api.nvim_win_get_config(winid).relative ~= "" then
            return true
        end

        local bufnr = vim.api.nvim_win_get_buf(winid)
        -- Only tint normal buffers.
        return vim.api.nvim_buf_get_option(bufnr, "buftype") ~= ""
    end,
}
