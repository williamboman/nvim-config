local lspconfig = require "lspconfig"
local configs = require "lspconfig.configs"
local lsp_installer = require "nvim-lsp-installer"
local server = require "nvim-lsp-installer.server"
local npm = require "nvim-lsp-installer.core.managers.npm"

local server_name = "my_bashls"

configs[server_name] = {
    default_config = {
        filetypes = { "sh" },
        root_dir = lspconfig.util.root_pattern ".git",
    },
}

local root_dir = server.get_server_root_path(server_name .. "_weirdness")

local my_server = server.Server:new {
    name = server_name,
    root_dir = root_dir,
    async = true,
    installer = npm.packages { "bash-language-server" },
    default_options = {
        cmd = { "bash-language-server", "start" },
        cmd_env = npm.env(root_dir),
    },
}

lsp_installer.register(my_server)
