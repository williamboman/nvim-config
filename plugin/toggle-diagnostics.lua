local ok, lsp_lines = pcall(require, "lsp_lines")
if not ok then
    return
end

lsp_lines.register_lsp_virtual_lines()

---@param mode '"virtual"' | '"lsp_lines"'
local function apply_mode(mode)
    vim.diagnostic.hide()
    if mode == "virtual" then
        vim.diagnostic.config {
            virtual_text = true,
            virtual_lines = false,
        }
    else
        vim.diagnostic.config {
            virtual_text = false,
            virtual_lines = true,
        }
    end
end

do
    local current_mode
    local function cycle_diagnostics()
        if current_mode ~= "lsp_lines" then
            current_mode = "lsp_lines"
            apply_mode "lsp_lines"
        else
            current_mode = "virtual"
            apply_mode "virtual"
        end
    end

    vim.keymap.set("n", "<M-d>", cycle_diagnostics)
end

-- Default config
vim.diagnostic.config {
    signs = false,
    float = {
        header = false,
        source = "always",
    },
}

apply_mode "virtual"
