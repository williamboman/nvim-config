local _ = require "mason-core.functional"

local M = {}

local parse_opts = _.compose(
    _.from_pairs,
    _.map(_.compose(function(arg)
        if #arg == 2 then
            return arg
        else
            return { arg[1], true }
        end
    end, _.split "=", _.gsub("^%-%-", "")))
)

---@param args string[]
---@return table<string, true|string> opts, string[] args
function M.parse_args(args)
    local opts_list, args = unpack(_.partition(_.starts_with "--", args))
    local opts = parse_opts(opts_list)
    return opts, args
end

return M
