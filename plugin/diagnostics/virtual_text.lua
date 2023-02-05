---@class Diagnostic
---@field bufnr integer?
---@field lnum integer
---@field end_lnum integer
---@field col integer
---@field end_col integer
---@field severity integer
---@field message string
---@field source string
---@field code string
---@field user_data any
---@field namespace integer : Not part of core diagnostics API.

---@param base_name string
local function make_highlight_map(base_name)
    local result = {}
    for level, name in ipairs(vim.diagnostic.severity) do
        name = name:sub(1, 1) .. name:sub(2):lower()
        result[level] = "Diagnostic" .. base_name .. name
    end

    return result
end

local line_highlight_map = make_highlight_map "Line"

---@param diagnostics Diagnostic[]
---@param namespace integer
local function prefix_source(diagnostics, namespace)
    return vim.tbl_map(function(diagnostic)
        diagnostic.namespace = namespace
        if not diagnostic.source then
            return diagnostic
        end

        local copy = vim.deepcopy(diagnostic)
        copy.message = string.format("%s: %s", diagnostic.source, diagnostic.message)
        return copy
    end, diagnostics)
end

---@param bufnr integer?
local function get_bufnr(bufnr)
    if not bufnr or bufnr == 0 then
        return vim.api.nvim_get_current_buf()
    end
    return bufnr
end

---@param diagnostics Diagnostic[]
local function diagnostic_lines(diagnostics)
    if not diagnostics then
        return {}
    end

    local diagnostics_by_line = {}
    for _, diagnostic in ipairs(diagnostics) do
        local line_diagnostics = diagnostics_by_line[diagnostic.lnum]
        if not line_diagnostics then
            line_diagnostics = {}
            diagnostics_by_line[diagnostic.lnum] = line_diagnostics
        end
        table.insert(line_diagnostics, diagnostic)
    end
    return diagnostics_by_line
end

---@type table<integer, table<integer, Diagnostic[]>>
local diagnostics_per_namespace = {}

local namespaces = {}

local function create_namespace()
    local namespace = vim.api.nvim_create_namespace ""
    namespaces[#namespaces + 1] = namespace
    diagnostics_per_namespace[namespace] = {}
    return namespace
end

---@param bufnr integer
---@param trigger_ns integer?
local function redraw_extmarks(bufnr, trigger_ns)
    ---@type Diagnostic[]
    local merged_diagnostics = {}

    for _, ns_diagnostics in pairs(diagnostics_per_namespace) do
        if ns_diagnostics[bufnr] then
            vim.list_extend(merged_diagnostics, ns_diagnostics[bufnr])
        end
    end

    for line, diagnostics in pairs(diagnostic_lines(merged_diagnostics)) do
        ---@type Diagnostic
        local highest_severity_diagnostic

        for i = 1, #diagnostics do
            local diagnostic = diagnostics[i]
            if diagnostic.namespace ~= trigger_ns then
                vim.api.nvim_buf_clear_namespace(bufnr, diagnostic.namespace, line, line + 1)
            end
            if not highest_severity_diagnostic or (diagnostic.severity < highest_severity_diagnostic.severity) then
                highest_severity_diagnostic = diagnostic
            end
        end

        vim.api.nvim_buf_set_extmark(bufnr, highest_severity_diagnostic.namespace, line, 0, {
            hl_mode = "combine",
            priority = 100,
            line_hl_group = line_highlight_map[highest_severity_diagnostic.severity],
            -- cursorline_hl_group = TODO lighter variants?,
        })
    end
end

---@param namespace integer
---@param bufnr integer?
---@param diagnostics Diagnostic[]
---@param opts table?
local function show(namespace, bufnr, diagnostics, opts)
    bufnr = get_bufnr(bufnr)
    opts = opts or {}

    local ns = vim.diagnostic.get_namespace(namespace)
    if not ns.user_data.line_highlight_ns then
        ns.user_data.line_highlight_ns = create_namespace()
    end
    diagnostics_per_namespace[ns.user_data.line_highlight_ns][bufnr] =
        prefix_source(diagnostics, ns.user_data.line_highlight_ns)
    redraw_extmarks(bufnr, ns.user_data.line_highlight_ns)
end

---@param namespace integer
---@param bufnr integer?
local function hide(namespace, bufnr)
    bufnr = get_bufnr(bufnr)
    local ns = vim.diagnostic.get_namespace(namespace)
    if ns.user_data.line_highlight_ns then
        vim.api.nvim_buf_clear_namespace(bufnr, ns.user_data.line_highlight_ns, 0, -1)
        diagnostics_per_namespace[ns.user_data.line_highlight_ns][bufnr] = nil
    end
end

vim.diagnostic.handlers.line_highlight = { show = show, hide = hide }
