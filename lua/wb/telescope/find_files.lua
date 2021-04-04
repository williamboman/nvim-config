local builtin = require('telescope.builtin')

local M = {}

M.find = function ()
    builtin.find_files({
        find_command = {
            'rg',
            '--hidden',
            '--no-ignore',
            '--follow',
            '--files',
            '--smart-case',
        }
    })
end

M.git_files = function ()
    builtin.git_files()
end

M.live_grep = function ()
    builtin.live_grep()
end

M.oldfiles = function ()
    builtin.oldfiles()
end

return M
