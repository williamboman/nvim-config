vim.cmd.packadd("mason.nvim")
vim.lsp.set_log_level("DEBUG")

function lazy_require(module)
    return setmetatable({}, {
        __index = function(self, key)
            self[key] = require(module)[key]
            return self[key]
        end,
    })
end

function defer(jit_fn)
    local has_executed_jit_fn = false
    return {
        keymap = function(...)
            local callback = select(3, ...)
            return vim.keymap.set(select(1, ...), select(2, ...), has_executed_jit_fn and callback or function(...)
                jit_fn()
                has_executed_jit_fn = true
                return callback(...)
            end, select(4, ...))
        end,
        require = function(module)
            if has_executed_jit_fn then
                return require(module)
            end
            return setmetatable({}, {
                __index = function(self, key)
                    return function(...)
                        if not has_executed_jit_fn then
                            jit_fn()
                            has_executed_jit_fn = true
                        end
                        self[key] = require(module)[key]
                        return self[key](...)
                    end
                end
            })
        end
    }
end

require("mason").setup({
    registries = {
        ("file:%s"):format(vim.fn.stdpath("config")),
        -- "file:~/dev/mason-registry",
        "github:mason-org/mason-registry",
    },
})

require("mason-plugin") {
    ["stevearc/dressing.nvim"] = "github-refs",
    ["lewis6991/gitsigns.nvim"] = "github-refs",
    ["DNLHC/glance.nvim"] = "github-refs",
    ["rebelot/kanagawa.nvim"] = "github-refs",
    ["stevearc/oil.nvim"] = "github-tags",
    ["nvim-lua/plenary.nvim"] = "github-refs",
    ["nvim-telescope/telescope.nvim"] = "github-refs",
    ["pmizio/typescript-tools.nvim"] = "github-refs",
    ["tpope/vim-fugitive"] = "github-refs",
    ["tpope/vim-sleuth"] = "github-refs",
    ["tpope/vim-surround"] = "github-refs",
    ["tpope/vim-unimpaired"] = "github-refs",
    ["ggandor/leap.nvim"] = "github-refs"
}
