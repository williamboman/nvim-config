local ok, colorizer = pcall(require, "colorizer")
if not ok then
    return
end

colorizer.setup({
    "scss",
    "html",
    css = { rgb_fn = true },
    javascript = { no_names = true, rgb_fn = true },
    javascriptreact = { no_names = true, rgb_fn = true },
    typescript = { no_names = true, rgb_fn = true },
    typescriptreact = { no_names = true, rgb_fn = true },
    lua = { no_names = true },
}, {
    RGB = true, -- #RGB hex codes
    RRGGBB = true, -- #RRGGBB hex codes
    RRGGBBAA = true, -- #RRGGBBAA hex codes
    rgb_fn = true, -- CSS rgb() and rgba() functions
    hsl_fn = true, -- CSS hsl() and hsla() functions
    css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
})
