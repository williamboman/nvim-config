local ok, notifier = pcall(require, "notifier")
if not ok then
    return
end

notifier.setup {
    status_width = function ()
        return math.floor(vim.o.columns / 2)
    end,
    notify = {
        clear_time = 5000
    }
}
