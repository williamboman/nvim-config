local ok, rust_tools = pcall(require, "rust-tools")
if not ok then
    return
end

rust_tools.setup {
    tools = {
        executor = require("rust-tools/executors").toggleterm,
        hover_actions = { border = "solid" },
    },
    server = {
        on_attach = function(_, bufnr)
            vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
                buffer = bufnr,
                command = "RustSetInlayHints",
            })
        end,
    },
}
