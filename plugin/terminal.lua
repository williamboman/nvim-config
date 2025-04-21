local api = vim.api
local filter = vim.tbl_filter

local function get_buf_var(bufnr, var)
    local ok, value = pcall(api.nvim_buf_get_var, bufnr, var)
    if ok then
        return value
    end
end

local function get_win_var(winnr, var)
    local ok, value = pcall(api.nvim_win_get_var, winnr, var)
    if ok then
        return value
    end
end

local function find_first(predicate, list)
    for _, item in ipairs(list) do
        if predicate(item) then
            return item
        end
    end
end

local function open_terminal(winnr, terminal_id)
    local terminal_buffer = find_first(function(bufnr)
        local ok, value = pcall(api.nvim_buf_get_var, bufnr, "terminal_id")
        return value == terminal_id
    end, api.nvim_list_bufs())

    if terminal_buffer then
        api.nvim_win_set_buf(winnr, terminal_buffer)
    else
        vim.cmd.term()
        vim.b.terminal_id = terminal_id
    end
    vim.w.terminal_id = terminal_id
    vim.wo.statusline = "term #" .. terminal_id .. " | \239\147\147 %{b:term_title}"
    vim.wo.winfixbuf = true
    vim.wo.winhighlight = "Normal:TermNormal"
end

vim.keymap.set("n", "<space>t", function()
    local original_terminal_id = vim.v.count
    local terminal_id = original_terminal_id
    if terminal_id == nil or terminal_id == 0 then
        terminal_id = 1
    end
    local tabpage = api.nvim_get_current_tabpage()
    local tabpage_windows = api.nvim_tabpage_list_wins(tabpage)
    local open_terminal_windows = filter(function(winnr)
        return get_win_var(winnr, "terminal_id") ~= nil
    end, tabpage_windows)

    if #open_terminal_windows > 0 then
        local open_terminal_window = find_first(function(winnr)
            return get_win_var(winnr, "terminal_id") == terminal_id
        end, open_terminal_windows)
        if open_terminal_window then
            api.nvim_win_close(open_terminal_window, true)
        else
            -- Close the only visible terminal window if the terminal that is being toggled is the default one (i.e.
            -- doesn't have v:count).
            if #open_terminal_windows == 1 and original_terminal_id == 0 then
                api.nvim_win_close(open_terminal_windows[1], true)
            else
                vim.fn.win_gotoid(open_terminal_windows[#open_terminal_windows])
                vim.cmd.vsp()
                open_terminal(api.nvim_get_current_win(), terminal_id)
            end
        end
    else
        vim.fn.win_gotoid(tabpage_windows[#tabpage_windows])
        vim.cmd.sp()
        vim.cmd.wincmd("J")
        open_terminal(api.nvim_get_current_win(), terminal_id)
    end
end)
