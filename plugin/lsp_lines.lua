local ok, lsp_lines = pcall(require, "lsp_lines")
if not ok then
    return
end

lsp_lines.setup()

-- Default config
vim.diagnostic.config {
    virtual_lines = false,
    signs = false,
    severity_sort = true,
    float = {
        header = false,
        source = "always",
    },
}

local Mode = {
    "Text",
    "Lines",
    "None",
}

local current_mode = 1

vim.keymap.set("n", "<M-d>", function()
    current_mode = (current_mode % #Mode) + 1
    if Mode[current_mode] == "Text" then
        vim.diagnostic.config {
            signs = false,
            underline = true,
            virtual_text = true,
            virtual_lines = false,
        }
    elseif Mode[current_mode] == "Lines" then
        vim.diagnostic.config {
            signs = false,
            underline = true,
            virtual_text = false,
            virtual_lines = true,
        }
    elseif Mode[current_mode] == "None" then
        vim.diagnostic.config {
            signs = true,
            underline = false,
            virtual_text = false,
            virtual_lines = false,
        }
    end
end, { desc = "Toggle lsp_lines" })
