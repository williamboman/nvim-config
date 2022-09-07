local ok, tint = pcall(require, "tint")
if not ok then
    return
end

tint.setup {
    tint = -20,
    saturation = 0.6,
    ignore = { "WinBar.*", "WinSeparator", "IndentBlankline.*", "SignColumn", "EndOfBuffer" },
    ignorefunc = function(winid)
        local bufnr = vim.api.nvim_win_get_buf(winid)
        -- Only tint normal buffers.
        return vim.api.nvim_buf_get_option(bufnr, "buftype") ~= ""
    end,
}
