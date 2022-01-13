if true then
    -- see https://github.com/ms-jpq/coq_nvim/issues/293
    return
end

COQsources = COQsources or {}

local uv = vim.loop

for _, v in ipairs { 1, 4 } do
    local name = ("uuid_v%d"):format(v)
    COQsources[name] = {
        name = name, -- this is displayed to the client
        fn = function(args, callback)
            -- 0 based
            local row, col = unpack(args.pos)

            local stdout = uv.new_pipe(false)
            local stdio = { nil, stdout, nil }

            local stdout_chunks = {}

            local handle
            handle = uv.spawn("python3", {
                args = { "-c", ("import uuid; print(uuid.uuid%d(), end='')"):format(v) },
                stdio = stdio,
                detached = false,
                hide = true,
            }, function(exit_code, signal)
                handle:close()
                if not stdout:is_closing() then
                    stdout:close()
                end
                if exit_code == 0 then
                    local uuid = stdout_chunks[1]
                    local text_edit = {
                        newText = uuid,
                        range = {
                            start = { line = row, character = col },
                            ["end"] = { line = row, character = col + 32 },
                        },
                    }
                    callback {
                        isIncomplete = false,
                        items = {
                            {
                                label = name,
                                textEdit = text_edit,
                                detail = uuid,
                                kind = vim.lsp.protocol.CompletionItemKind.Text,
                                filterText = "filter text??",
                            },
                        },
                    }
                else
                    callback(nil)
                end
            end)

            stdout:read_start(function(err, data)
                if data ~= nil then
                    stdout_chunks[#stdout_chunks + 1] = data
                else
                    stdout:read_stop()
                    stdout:close()
                end
            end)

            return function()
                if not handle:is_closing() then
                    handle:close()
                end
            end
        end,
    }
end
