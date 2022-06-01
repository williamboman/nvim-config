local ok, rust_tools = pcall(require, "rust-tools")
if not ok then
    return
end

rust_tools.setup {
    tools = {
        executor = require("rust-tools/executors").toggleterm,
        hover_actions = { border = "solid" },
    },
}

local inlay_fix
inlay_fix = vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
    pattern = "*.rs",
    callback = function()
        vim.cmd [[RustSetInlayHints]]
        vim.api.nvim_del_autocmd(inlay_fix)
    end,
})
