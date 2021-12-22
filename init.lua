function P(...)
    local args = { n = select("#", ...), ... }
    for i = 1, args.n do
        args[i] = vim.inspect(args[i])
    end
    print(unpack(args))
end

if not pcall(require, "impatient") then
    print("Failed to load impatient.")
end

require "wb.settings"
require "wb.plugins"
