local M = {}

function M.setup()
    -- these are same as default, but we define them ourselves for better autopairs interop
    vim.api.nvim_set_keymap("i", "<esc>", [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
    vim.api.nvim_set_keymap("i", "<c-c>", [[pumvisible() ? "<c-e><c-c>" : "<c-c>"]], { expr = true, noremap = true })
    vim.api.nvim_set_keymap("i", "<tab>", [[pumvisible() ? "<c-n>" : "<tab>"]], { expr = true, noremap = true })
    vim.api.nvim_set_keymap("i", "<s-tab>", [[pumvisible() ? "<c-p>" : "<bs>"]], { expr = true, noremap = true })

    local sources = {
        { src = "bc", short_name = "MATH", precision = 6 },
        { src = "repl", unsafe = { "rm", "sudo", "mv", "cp" } },
    }
    if vim.fn.executable "figlet" == 1 then
        table.insert(sources, { src = "figlet" })
    end
    if vim.fn.executable "cowsay" == 1 then
        table.insert(sources, { src = "cow" })
    end
    require "coq_3p"(sources)
    require "wb.coq_3p.uuid"
end

return M
