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
    log_level = vim.log.levels.DEBUG,
    -- install_root_dir = "/var/folders/g_/krmqfsqd471dm6rkg1015yz40000gn/T/tmp.OmuQ5zxbXX",
    registries = {
        ("file:%s"):format(vim.fn.stdpath("config")),
        -- "github:mason-org/mason-registry",
        -- "github:nvim-java/mason-registry",
        "file:~/dev/mason-registry",
    },
    ui = {
        -- check_outdated_packages_on_open = false,
    }
})

require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls" }
}

-- local registry = require("mason-registry")
-- registry.sources:prepend(("file:%s"):format(vim.fn.stdpath("config")))

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
