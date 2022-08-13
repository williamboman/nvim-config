local ok, headlines = pcall(require, "headlines")
if not ok then
    return
end

headlines.setup()
