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

---@param base_name string
local function make_highlight_map(base_name)
    local result = {}
    for level, name in ipairs(vim.diagnostic.severity) do
        name = name:sub(1, 1) .. name:sub(2):lower()
        result[level] = "Diagnostic" .. base_name .. name
    end

    return result
end

-- TODO rename?
local virtual_text_highlight_map = make_highlight_map "VirtualText"
local line_highlight_map = make_highlight_map "Line"

---@param diagnostics Diagnostic[]
local function prefix_source(diagnostics)
    return vim.tbl_map(function(diagnostic)
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

---TODO: this won't play nicely with anticonceal text
---@param bufnr integer
---@param line integer
---@param virt_texts table[]
local function get_virt_text_pos(bufnr, line, virt_texts)
    local virt_text_length = 0
    for _, virt_text in ipairs(virt_texts) do
        virt_text_length = virt_text_length + #virt_text[1]
    end
    local line_contents = vim.api.nvim_buf_get_lines(bufnr, line, line + 1, true)[1]
    return ((vim.o.columns - #line_contents) >= virt_text_length) and "right_align" or "eol"
end

local namespaces = {}

local function create_namespace()
    local namespace = vim.api.nvim_create_namespace ""
    namespaces[#namespaces + 1] = namespace
    return namespace
end

local queue = {}
local is_scheduled = false

local function flush()
    local merged_diagnostics_by_bufnr = {}
    for _, item in ipairs(queue) do
        if not merged_diagnostics_by_bufnr[item.bufnr] then
            merged_diagnostics_by_bufnr[item.bufnr] = {}
        end
        if not merged_diagnostics_by_bufnr[item.bufnr][item.line] then
            merged_diagnostics_by_bufnr[item.bufnr][item.line] = {}
        end
        table.insert(merged_diagnostics_by_bufnr[item.bufnr][item.line], item)
    end

    for bufnr, line_diagnostics in pairs(merged_diagnostics_by_bufnr) do
        for line, diagnostic_sources in pairs(line_diagnostics) do
            local virt_texts_by_ns = {}
            local virt_text_length = 0
            local severity
            local diagnostic_indicator = "■ "
            local suffix = "   "
            ---@type {diagnostic: Diagnostic, ns: integer}?
            local visible_diagnostic

            for _, diagnostic_source in ipairs(diagnostic_sources) do
                if not virt_texts_by_ns[diagnostic_source.ns] then
                    virt_texts_by_ns[diagnostic_source.ns] = {}
                end

                for _, diagnostic in ipairs(diagnostic_source.diagnostics) do
                    table.insert(
                        virt_texts_by_ns[diagnostic_source.ns],
                        { diagnostic_indicator, virtual_text_highlight_map[diagnostic.severity] }
                    )
                    virt_text_length = virt_text_length + #diagnostic_indicator

                    if not severity or severity > diagnostic.severity then
                        severity = diagnostic.severity
                    end

                    if diagnostic.message then
                        if
                            not visible_diagnostic
                            or visible_diagnostic.diagnostic.severity > diagnostic.severity
                            or #visible_diagnostic.diagnostic.message > #diagnostic.message
                        then
                            visible_diagnostic = { ns = diagnostic_source.ns, diagnostic = diagnostic }
                        end
                    end
                end
            end

            if visible_diagnostic then
                table.insert(virt_texts_by_ns[visible_diagnostic.ns], {
                    visible_diagnostic.diagnostic.message .. suffix,
                    virtual_text_highlight_map[visible_diagnostic.diagnostic.severity],
                })
            end

            for ns, virt_texts in pairs(virt_texts_by_ns) do
                vim.api.nvim_buf_set_extmark(bufnr, ns, line, 0, {
                    hl_mode = "combine",
                    priority = 100,
                    line_hl_group = line_highlight_map[severity],
                    -- cursorline_hl_group = TODO lighter variants?,
                    virt_text = virt_texts,
                    virt_text_pos = get_virt_text_pos(bufnr, line, virt_texts),
                    -- virt_text_pos = "right_align",
                })
            end
        end
    end
    queue = {}
    is_scheduled = false
end

---@param namespace integer
---@param bufnr integer?
---@param diagnostics Diagnostic[]
---@param opts table?
local function show(namespace, bufnr, diagnostics, opts)
    bufnr = get_bufnr(bufnr)
    opts = opts or {}

    diagnostics = prefix_source(diagnostics)

    local ns = vim.diagnostic.get_namespace(namespace)
    if not ns.user_data.right_align_ns then
        ns.user_data.right_align_ns = create_namespace()
    end

    for line, line_diagnostics in pairs(diagnostic_lines(diagnostics)) do
        queue[#queue + 1] = {
            bufnr = bufnr,
            ns = ns.user_data.right_align_ns,
            line = line,
            diagnostics = line_diagnostics,
        }
        if not is_scheduled then
            is_scheduled = true
            flush()
        end
    end
end

---@param namespace integer
---@param bufnr integer?
local function hide(namespace, bufnr)
    bufnr = get_bufnr(bufnr)
    local ns = vim.diagnostic.get_namespace(namespace)
    if ns.user_data.right_align_ns then
        vim.api.nvim_buf_clear_namespace(bufnr, ns.user_data.right_align_ns, 0, -1)
    end
end

local unused = "here"

local augroup = vim.api.nvim_create_augroup("RightAlign", {})
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = augroup,
    callback = function(args)
        local lineno = vim.fn.line "." - 1
        for _, ns in ipairs(namespaces) do
            local extmarks = vim.api.nvim_buf_get_extmarks(
                args.buf,
                ns,
                { lineno, 0 },
                { lineno, 0 },
                { details = true }
            )
            for _, extmark_tuple in ipairs(extmarks) do
                local extmark = extmark_tuple[4]
                vim.api.nvim_buf_set_extmark(
                    args.buf,
                    ns,
                    extmark_tuple[2],
                    extmark_tuple[3],
                    vim.tbl_extend("force", extmark, {
                        id = extmark_tuple[1],
                        virt_text_pos = get_virt_text_pos(args.buf, lineno, extmark.virt_text),
                    })
                )
            end
        end
    end,
})

vim.diagnostic.handlers.right_align = { show = show, hide = hide }
