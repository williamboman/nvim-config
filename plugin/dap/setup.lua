local ok1, dap_virtual_text = pcall(require, "nvim-dap-virtual-text")
local ok2, dapui = pcall(require, "dapui")
local ok3, dap = pcall(require, "dap")
if not ok1 or not ok2 or not ok3 then
    return
end

dap_virtual_text.setup()
dapui.setup()

local map = vim.keymap.set

local function c(func, opts)
    return function()
        func(opts)
    end
end

map("n", "<leader>d.", c(dap.run_to_cursor))
map("n", "<leader>dJ", c(dap.down))
map("n", "<leader>dK", c(dap.up))
map("n", "<leader>dL", function()
    dap.list_breakpoints()
    vim.cmd.copen()
end)
map("n", "<leader>dX", function()
    dap.terminate()
    dapui.close()
end)
map("n", "<leader>da", c(dap.toggle_breakpoint))
map("n", "<leader>dc", c(dap.continue))
map("n", "<leader>dh", c(dap.step_back))
map("n", "<leader>dj", c(dap.step_into))
map("n", "<leader>dk", c(dap.step_out))
map("n", "<leader>dl", c(dap.step_over))
map("n", "<leader>dr", c(dap.run_last))
map("n", "<leader>dx", c(dap.clear_breakpoints))

map("v", "<M-e>", c(dapui.eval))
map("n", "<leader>d?", c(require("dap.ui.widgets").hover))

dap.listeners.after.event_initialized["dapui_config"] = c(dapui.open)
dap.listeners.after.event_loadedSource["dapui_config"] = c(dapui.open)

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "WarningMsg" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "MatchParen", linehl = "CursorLine" })

-- TODO: add <cexpr> to watch expressions
