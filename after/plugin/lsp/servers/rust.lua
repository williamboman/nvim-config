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

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
    pattern = "*.rs",
    callback = function()
        vim.cmd [[RustSetInlayHints]]
    end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "rust",
    callback = function()
        vim.cmd [[RustSetInlayHints]]
    end,
})
