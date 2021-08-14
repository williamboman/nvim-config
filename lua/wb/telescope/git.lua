local builtin = require "telescope.builtin"

local M = {}

M.bcommits = function()
    builtin.git_bcommits()
end

M.commits = function()
    builtin.git_commits()
end

M.modified_files = function()
    builtin.git_status()
end

return M
