local ok, stabilize = pcall(require, "stabilize")
if not ok then
    return
end

stabilize.setup()
