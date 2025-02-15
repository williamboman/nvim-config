vim.api.nvim_create_user_command("MasonGenerate", function(args)
    local a = require("mason-core.async")
    local cmdline = require("mason-plugin.cmdline")
    local providers = require("mason-plugin.providers")

    local opts, plugins = cmdline.parse_args(args.fargs)
    local provider = providers[opts.datasource]

    if provider == nil then
        vim.cmd.echoerr([["--datasource needs to be one of: ]] .. table.concat(vim.tbl_keys(providers), ", ") .. '"')
        return
    end

    a.run_blocking(function()
        for _, plugin in ipairs(plugins) do
            provider(plugin):on_failure(vim.schedule_wrap(function(err)
                vim.api.nvim_err_writeln(tostring(err))
            end))
        end
    end)
end, {
    nargs = "+",
    ---@param arg_lead string
    complete = function(arg_lead)
        local _ = require("mason-core.functional")
        if _.starts_with("--", arg_lead) then
            return _.filter(_.starts_with(arg_lead), {
                "--datasource=github-refs",
                "--datasource=github-tags",
            })
        end
    end,
})

return function(spec)
    vim.api.nvim_create_user_command("MasonInstallPlugins", function(args)
        local _ = require "mason-core.functional"
        for plugin, datasource in pairs(spec) do
            vim.cmd(([[MasonGenerate --datasource=%s %s]]):format(datasource, plugin))
        end
        local plugins = _.compose(
            _.map(_.compose(_.head, _.match("/(.+)$"))),
            _.map(_.nth(1)),
            _.to_pairs
        )(spec)
        vim.cmd([[MasonInstall ]] .. _.join(" ", plugins))
    end, {
        nargs = 0,
    })
end
