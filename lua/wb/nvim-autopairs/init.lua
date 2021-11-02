local remap = vim.api.nvim_set_keymap
local npairs = require "nvim-autopairs"

local M = {}

function M.setup()
    npairs.setup { map_bs = false }

    vim.g.coq_settings = { keymap = { recommended = false } }

    -- these mappings are coq recommended mappings unrelated to nvim-autopairs
    remap("i", "<esc>", [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
    remap("i", "<c-c>", [[pumvisible() ? "<c-e><c-c>" : "<c-c>"]], { expr = true, noremap = true })
    remap("i", "<tab>", [[pumvisible() ? "<c-n>" : "<tab>"]], { expr = true, noremap = true })
    remap("i", "<s-tab>", [[pumvisible() ? "<c-p>" : "<bs>"]], { expr = true, noremap = true })

    -- skip it, if you use another global object
    _G.Autopairs = {}

    Autopairs.CR = function()
        if vim.fn.pumvisible() ~= 0 then
            if vim.fn.complete_info({ "selected" }).selected ~= -1 then
                return npairs.esc "<c-y>"
            else
                return npairs.esc "<c-e>" .. npairs.autopairs_cr()
            end
        else
            return npairs.autopairs_cr()
        end
    end
    remap("i", "<cr>", "v:lua.Autopairs.CR()", { expr = true, noremap = true })

    Autopairs.BS = function()
        if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ "mode" }).mode == "eval" then
            return npairs.esc "<c-e>" .. npairs.autopairs_bs()
        else
            return npairs.autopairs_bs()
        end
    end
    remap("i", "<bs>", "v:lua.Autopairs.BS()", { expr = true, noremap = true })
end

return M
