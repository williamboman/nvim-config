if vim.fn.has "mac" == 1 then
    -- https://stackoverflow.com/a/65357166/1310983
    local exit_code = os.execute "defaults read -g AppleInterfaceStyle"
    if exit_code == 0 then
        -- Dark mode
        vim.cmd.colorscheme { "kanagawa" }
    else
        vim.cmd.colorscheme { "github_light_default" }
    end
else
    -- Dark mode
    vim.cmd.colorscheme { "kanagawa" }
end
