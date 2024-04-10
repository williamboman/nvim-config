local ok, indent_blankline = pcall(require, "ibl")
if not ok then
    return
end

local is_windows = vim.fn.has "win32" == 1

indent_blankline.setup {
    scope = {
        show_start = not is_windows,
    },
    indent = {
        char = "▏",
    },
    exclude = {
        filetypes = { "help", "packer" },
        buftypes = { "terminal", "nofile" },
    },
}
