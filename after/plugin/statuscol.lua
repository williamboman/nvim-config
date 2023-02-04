local ok, statuscol = pcall(require, "statuscol")
if not ok then
    return
end

statuscol.setup {
    foldfunc = "builtin",
    setopt = true,
    order = "NSFs",
}
