local ok, indent_blankline = pcall(require, "indent_blankline")
if not ok then
    return
end

indent_blankline.setup {
    char = "▏",
    use_treesitter_scope = true,
    buftype_exclude = { "terminal", "nofile" },
    filetype_exclude = { "help", "packer" },
    show_current_context = true,
    show_current_context_start = true,
}
