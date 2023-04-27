local ok, indent_blankline = pcall(require, "indent_blankline")
if not ok then
    return
end

local is_windows = vim.fn.has "win32" == 1

indent_blankline.setup {
    char = "▏",
    use_treesitter_scope = not is_windows,
    show_current_context = not is_windows,
    show_current_context_start = not is_windows,
    buftype_exclude = { "terminal", "nofile" },
    filetype_exclude = { "help", "packer" },
}
