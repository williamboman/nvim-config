local ok, from_vscode = pcall(require, "luasnip.loaders.from_vscode")
if not ok then
    return
end

from_vscode.lazy_load()
