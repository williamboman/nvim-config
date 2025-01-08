vim.api.nvim_create_autocmd("LspAttach", {
    once = true,
    callback = function()
        vim.cmd.packadd "glance.nvim"
        local glance = require "glance"

        glance.setup {
            mappings = {
                list = {
                    ["<C-t>"] = glance.actions.jump_tab,
                    ["<C-v>"] = glance.actions.jump_vsplit,
                    ["<C-s>"] = glance.actions.jump_split,
                    ["<C-q>"] = glance.actions.quickfix,
                    ["s"] = false,
                    ["t"] = false,
                    ["v"] = false,
                },
            },
            hooks = {
                -- Don’t open glance when there is only one result and it is located in the current buffer, open otherwise.
                before_open = function(results, open, jump)
                    local uri = vim.uri_from_bufnr(0)
                    if #results == 1 then
                        local target_uri = results[1].uri or results[1].targetUri

                        if target_uri == uri then
                            jump(results[1])
                        else
                            open(results)
                        end
                    else
                        open(results)
                    end
                end,
            },
        }
    end,
})
