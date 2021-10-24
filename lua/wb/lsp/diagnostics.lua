-- Much of this code is copied from nvim source directly, with minor modifications & simplifications.

local api = vim.api
local util = vim.lsp.util
local diagnostics = vim.lsp.diagnostic
local protocol = vim.lsp.protocol

local DiagnosticSeverity = protocol.DiagnosticSeverity

local M = {}

local padding = {
    pad_top = 1,
    pad_bottom = 1,
    pad_right = 3,
    pad_left = 3,
}

--- Trims empty lines from input and pad left and right with spaces
---
---@param contents table of lines to trim and pad
---@param opts table with optional fields
---             - pad_left   number of columns to pad contents at left (default 1)
---             - pad_right  number of columns to pad contents at right (default 1)
---             - pad_top    number of lines to pad contents at top (default 0)
---             - pad_bottom number of lines to pad contents at bottom (default 0)
---@return table of trimmed and padded lines
local function trim_and_pad(contents, opts)
    opts = opts or {}
    local left_padding = (" "):rep(opts.pad_left or 1)
    local right_padding = (" "):rep(opts.pad_right or 1)
    contents = util.trim_empty_lines(contents)
    for i, line in ipairs(contents) do
        contents[i] = string.format("%s%s%s", left_padding, line:gsub("\r", ""), right_padding)
    end
    if opts.pad_top then
        for _ = 1, opts.pad_top do
            table.insert(contents, 1, "")
        end
    end
    if opts.pad_bottom then
        for _ = 1, opts.pad_bottom do
            table.insert(contents, "")
        end
    end
    return contents
end

--- Computes size of float needed to show contents (with optional wrapping)
---
--@param contents table of lines to show in window
--@param opts dictionary with optional fields
--             - height  of floating window
--             - width   of floating window
--             - wrap_at character to wrap at for computing height
--             - max_width  maximal width of floating window
--             - max_height maximal height of floating window
--@returns width,height size of float
local function make_floating_popup_size(contents, opts)
    opts = opts or {}

    local width = opts.width
    local height = opts.height
    local wrap_at = opts.wrap_at
    local max_width = opts.max_width
    local max_height = opts.max_height
    local line_widths = {}

    if not width then
        width = 0
        for i, line in ipairs(contents) do
            -- TODO(ashkan) use nvim_strdisplaywidth if/when that is introduced.
            line_widths[i] = vim.fn.strdisplaywidth(line)
            width = math.max(line_widths[i], width)
        end
    end
    if max_width then
        width = math.min(width, max_width)
        wrap_at = math.min(wrap_at or max_width, max_width)
    end

    if not height then
        height = #contents
        if wrap_at and width >= wrap_at then
            height = 0
            if vim.tbl_isempty(line_widths) then
                for _, line in ipairs(contents) do
                    local line_width = vim.fn.strdisplaywidth(line)
                    height = height + math.ceil(line_width / wrap_at)
                end
            else
                for i = 1, #contents do
                    height = height + math.max(1, math.ceil(line_widths[i] / wrap_at))
                end
            end
        end
    end
    if max_height then
        height = math.min(height, max_height)
    end

    return width, height
end

--- Shows contents in a floating window.
---
--@param contents table of lines to show in window
--@param syntax string of syntax to set for opened buffer
--@returns bufnr,winnr buffer and window number of the newly created floating
local function open_floating_preview(contents, syntax)
    -- Clean up input: trim empty lines from the end, pad
    contents = trim_and_pad(contents, padding)

    -- Compute size of float needed to show (wrapped) lines
    local width, height = make_floating_popup_size(contents, {
        max_width = 130,
    })

    local floating_bufnr = api.nvim_create_buf(false, true)
    if syntax then
        api.nvim_buf_set_option(floating_bufnr, "syntax", syntax)
    end
    local float_option = util.make_floating_popup_options(width, height)
    local floating_winnr = api.nvim_open_win(floating_bufnr, true, float_option)
    api.nvim_command "noautocmd wincmd p"
    if syntax == "markdown" then
        api.nvim_win_set_option(floating_winnr, "conceallevel", 2)
    end
    api.nvim_win_set_option(floating_winnr, "winblend", 10)
    api.nvim_buf_set_lines(floating_bufnr, 0, -1, true, contents)
    api.nvim_buf_set_option(floating_bufnr, "modifiable", false)
    api.nvim_buf_set_option(floating_bufnr, "bufhidden", "wipe")
    util.close_preview_autocmd({ "CursorMoved", "CursorMovedI", "InsertEnter" }, floating_winnr)
    return floating_bufnr, floating_winnr
end

local floating_severity_highlight_name = {
    [DiagnosticSeverity.Error] = "DiagnosticFloatingError",
    [DiagnosticSeverity.Warning] = "DiagnosticFloatingWarn",
    [DiagnosticSeverity.Information] = "DiagnosticFloatingInfo",
    [DiagnosticSeverity.Hint] = "DiagnosticFloatingHint",
}

--- Open a floating window with the diagnostics from {line_nr}
---
--- The floating window can be customized with the following highlight groups:
--- <pre>
--- LspDiagnosticsFloatingError
--- LspDiagnosticsFloatingWarning
--- LspDiagnosticsFloatingInformation
--- LspDiagnosticsFloatingHint
--- </pre>
---@param bufnr number The buffer number
---@param line_nr number The line number
---@param client_id number|nil the client id
---@return table {popup_bufnr, win_id}
function M.show_line_diagnostics(bufnr, line_nr, client_id)
    bufnr = bufnr or 0
    line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)

    local lines = {}
    local highlights = {}

    local line_diagnostics = diagnostics.get_line_diagnostics(bufnr, line_nr, {}, client_id)
    if vim.tbl_isempty(line_diagnostics) then
        return
    end

    for i, diagnostic in ipairs(line_diagnostics) do
        local prefix = string.format("%d. (%s) ", i, diagnostic.source or "unknown")
        local hiname = floating_severity_highlight_name[diagnostic.severity]
        assert(hiname, "unknown severity: " .. tostring(diagnostic.severity))

        local message_lines = vim.split(diagnostic.message, "\n", true)

        table.insert(lines, prefix .. message_lines[1])
        table.insert(highlights, { #prefix, hiname })
        for j = 2, #message_lines do
            table.insert(lines, message_lines[j])
            table.insert(highlights, { 0, hiname })
        end
    end

    local popup_bufnr, winnr = open_floating_preview(lines, "plaintext")
    for i, hi in ipairs(highlights) do
        local prefixlen, hiname = unpack(hi)
        api.nvim_buf_add_highlight(popup_bufnr, -1, "Comment", i - 1 + padding.pad_top, padding.pad_left, padding.pad_left + prefixlen)
        api.nvim_buf_add_highlight(popup_bufnr, -1, hiname, i - 1 + padding.pad_top, prefixlen + padding.pad_left, -1)
    end

    return popup_bufnr, winnr
end

function M.goto_next(opts)
    opts = vim.tbl_deep_extend("error", {
        enable_popup = false,
    }, opts or {})

    vim.diagnostic.goto_next(opts)

    local win_id = opts.win_id or vim.api.nvim_get_current_win()

    vim.schedule(function()
        M.show_line_diagnostics(vim.api.nvim_win_get_buf(win_id))
    end)
end

function M.goto_prev(opts)
    opts = vim.tbl_deep_extend("error", {
        enable_popup = false,
    }, opts or {})

    vim.diagnostic.goto_prev(opts)

    local win_id = opts.win_id or vim.api.nvim_get_current_win()

    vim.schedule(function()
        M.show_line_diagnostics(vim.api.nvim_win_get_buf(win_id))
    end)
end

return M
