local source = {}

---Source constructor.
source.new = function(uuid_version)
    local self = setmetatable({}, { __index = source })
    self.uuid_version = uuid_version
    return self
end

---Return the source is available or not.
---@return boolean
function source:is_available()
    return true
end

---Return the source name for some information.
function source:get_debug_name()
    return "uuidv" .. self.uuid_version
end

---Return keyword pattern which will be used...
---  1. Trigger keyword completion
---  2. Detect menu start offset
---  3. Reset completion state
---@param params cmp.SourceBaseApiParams
---@return string
function source:get_keyword_pattern(params)
    return "uuidv" .. self.uuid_version
end

---Return trigger characters.
---@param params cmp.SourceBaseApiParams
---@return string[]
function source:get_trigger_characters(params)
    return { "u" }
end

---Invoke completion (required).
---  If you want to abort completion, just call the callback without arguments.
---@param params cmp.SourceCompletionApiParams
---@param callback fun(response: lsp.CompletionResponse|nil)
function source:complete(params, callback)
    callback {
        items = {
            {
                word = "word",
                label = "label",
                filterText = "filterText",
                textEdit = {
                    range = {
                        start = {
                            line = params.context.cursor.row - 1,
                            character = params.context.cursor.col - 1,
                        },
                        ["end"] = {
                            line = params.context.cursor.row - 1,
                            character = 32 + params.context.cursor.col - 1,
                        },
                    },
                    newText = "fake uuid",
                },
            },
        },
    }
end

---Resolve completion item that will be called when the item selected or before the item confirmation.
---@param completion_item lsp.CompletionItem
---@param callback fun(completion_item: lsp.CompletionItem|nil)
-- function source:resolve(completion_item, callback)
--     callback(completion_item)
-- end

---Execute command that will be called when after the item confirmation.
---@param completion_item lsp.CompletionItem
---@param callback fun(completion_item: lsp.CompletionItem|nil)
-- function source:execute(completion_item, callback)
--     callback(completion_item)
-- end

-- require("cmp").register_source(source.new(1))
require("cmp").register_source("uuidv4", source.new(4))
