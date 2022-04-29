local ok, rust_tools = pcall(require, "rust-tools")
if not ok then
    return
end

rust_tools.setup {}

