local ok, typescript = pcall(require, "typescript")
if not ok then
    return
end

typescript.setup {}
