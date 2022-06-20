local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
    return
end

local function progress_handler()
    ---@type table<string, boolean>
    local tokens = {}
    ---@type table<string, boolean>
    local ready_projects = {}
    ---@param result {type:"Starting"|"Started"|"ServiceReady", message:string}
    return function(_, result, ctx)
        local cwd = vim.loop.cwd()
        if ready_projects[cwd] then
            return
        end
        local token = tokens[cwd] or vim.tbl_count(tokens)
        if result.type == "Starting" and not tokens[cwd] then
            tokens[cwd] = token
            vim.lsp.handlers["$/progress"](nil, {
                token = token,
                value = {
                    kind = "begin",
                    title = "jdtls",
                    message = result.message,
                    percentage = 0,
                },
            }, ctx)
        elseif result.type == "Starting" then
            local _, percentage_index = string.find(result.message, "^%d%d?%d?")
            local percentage = 0
            local message = result.message
            if percentage_index then
                percentage = tonumber(string.sub(result.message, 1, percentage_index))
                message = string.sub(result.message, percentage_index + 3)
            end

            vim.lsp.handlers["$/progress"](nil, {
                token = token,
                value = {
                    kind = "report",
                    message = message,
                    percentage = percentage,
                },
            }, ctx)
        elseif result.type == "Started" then
            vim.lsp.handlers["$/progress"](nil, {
                token = token,
                value = {
                    kind = "report",
                    message = result.message,
                    percentage = 100,
                },
            }, ctx)
        elseif result.type == "ServiceReady" then
            ready_projects[cwd] = true
            vim.lsp.handlers["$/progress"](nil, {
                token = token,
                value = {
                    kind = "end",
                    message = result.message,
                },
            }, ctx)
        end
    end
end

lspconfig.jdtls.setup {
    use_lombok_agent = true,
    handlers = {
        ["language/status"] = progress_handler,
    },
}
