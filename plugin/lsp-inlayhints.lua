local status_ok, hints = pcall(require, "lsp-inlayhints")
if not status_ok then
    return
end

local group = vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
        if not (args.data and args.data.client_id) then
            return
        end

        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        hints.on_attach(client, bufnr)
    end,
})

hints.setup {
    inlay_hints = {
        parameter_hints = {
            show = true,
        },
        type_hints = {
            show = true,
        },
        label_formatter = function(labels, kind, opts, client_name)
            if kind == 2 and not opts.parameter_hints.show then
                return ""
            elseif not opts.type_hints.show then
                return ""
            end

            return table.concat(labels or {}, ", ")
        end,
        virt_text_formatter = function(label, hint, opts, client_name)
            local virt_text = {}
            virt_text[#virt_text + 1] = { " ", "" }
            virt_text[#virt_text + 1] = { "", "LspInlayHintBorder" }
            virt_text[#virt_text + 1] = { label, opts.highlight }
            virt_text[#virt_text + 1] = { "", "LspInlayHintBorder" }
            virt_text[#virt_text + 1] = { " ", "" }
            return virt_text
        end,
    },
}
