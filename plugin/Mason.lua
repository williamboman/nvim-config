local ok, mason = pcall(require, "mason")
if not ok then
    return
end

mason.setup {
    max_concurrent_installers = 10,
    log_level = vim.log.levels.DEBUG,
    ui = {
        icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
        },
    },
}
