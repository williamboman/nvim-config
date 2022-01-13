local M = {}

function M.setup()
    local sources = {
        { src = "copilot", short_name = "COP", accept_key = "<c-f>" },
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
