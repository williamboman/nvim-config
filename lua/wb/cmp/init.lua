local M = {}

function M.setup()
    local cmp = require "cmp"
    local luasnip = require "luasnip"
    local mapping = cmp.mapping

    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
    end

    cmp.setup {
        formatting = {
            format = require("lspkind").cmp_format {
                with_text = true,
            },
        },
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        mapping = {
            -- TODO add mapping for sending docs to preview buffer
            ["<C-d>"] = mapping(mapping.scroll_docs(8), { "i" }),
            ["<C-u>"] = mapping(mapping.scroll_docs(-8), { "i" }),
            ["<C-Space>"] = mapping.complete(),
            ["<C-e>"] = mapping.abort(),
            ["<CR>"] = mapping.confirm { select = false },
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        },
        sources = {
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" },
            { name = "calc" },
            { name = "tmux" },
        },
    }
end

return M
