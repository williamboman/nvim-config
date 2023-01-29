local ok, glance = pcall(require, "glance")
if not ok then
    return
end

glance.setup {
    mappings = {
        list = {
            ["<C-j>"] = glance.actions.next_location,
            ["<C-k>"] = glance.actions.previous_location,
            ["<C-t>"] = glance.actions.jump_tab,
            ["<C-v>"] = glance.actions.jump_vsplit,
            ["<C-x>"] = glance.actions.jump_split,
            ["s"] = false,
            ["t"] = false,
            ["v"] = false,
            ["<C-q>"] = glance.actions.quickfix,
        },
    },
}
