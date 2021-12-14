function P(...)
    print(vim.inspect(...))
end

if not pcall(require, "impatient") then
    print("Failed to load impatient.")
end
require "wb.plugins"
require "wb.settings"
