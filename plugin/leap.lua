local ok, leap = pcall(require, "leap")

if not ok then
    return
end

leap.setup {
    case_insensitive = false,
}
leap.set_default_keymaps()
