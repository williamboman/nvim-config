vim.lsp.config("lua-language-server", {
    settings = {
        Lua = {
            format = {
                enable = false,
            },
            hint = {
                enable = true,
                arrayIndex = "Disable", -- "Enable", "Auto", "Disable"
                await = true,
                paramName = "All", -- "All", "Literal", "Disable"
                paramType = true,
                semicolon = "Disable", -- "All", "SameLine", "Disable"
                setType = true,
            },
            diagnostics = {
                globals = { "P" },
            },
            runtime = {
                version = "LuaJIT"
            },
            workspace = {
                checkThirdParty = false,
            },
        },
    },
})
