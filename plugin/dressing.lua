local ok, dressing = pcall(require, "dressing")
if not ok then
    return
end

dressing.setup {
    input = {
        enabled = false, -- native vim input is pretty nice for many reasons
        winblend = 10,
        winhighlight = "Normal:DressingInputNormalFloat,NormalFloat:DressingInputNormalFloat,FloatBorder:DressingInputFloatBorder",
        border = "single",
    },
}
