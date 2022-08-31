local ok, notifier = pcall(require, "notifier")
if not ok then
    return
end

notifier.setup {
    status_width = function ()
        return vim.o.columns
    end,
    notify = {
        clear_time = 5000
    }
}
