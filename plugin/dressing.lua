local ok, dressing = pcall(require, "dressing")
if not ok then
    return
end

dressing.setup {
    input = {
        winblend = 10,
        winhighlight = "Normal:DressingInputNormalFloat,NormalFloat:DressingInputNormalFloat,FloatBorder:DressingInputFloatBorder",
        border = "single",
    },
}
