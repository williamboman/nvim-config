local M = {}

---@param pkg_name string
---@param template string
function M.write(pkg_name, template)
    ---@param ctx table
    return function(ctx)
        local fs = require("mason-core.fs")
        local contents = template:gsub("%%{([^}]+)}", ctx)

        local package_root = vim.fs.joinpath(vim.fn.stdpath("config"), "packages")
        local package_dir = vim.fs.joinpath(package_root, pkg_name)
        local package_file = vim.fs.joinpath(package_dir, "package.yaml")

        if not fs.sync.dir_exists(package_dir) then
            fs.sync.mkdirp(package_dir)
        elseif fs.sync.file_exists(package_file) then
            fs.sync.unlink(package_file)
        end

        fs.sync.write_file(package_file, contents)
    end
end

return M
