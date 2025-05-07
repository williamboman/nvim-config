return {
  on_attach = function ()
    print("rust_analyzer attached")
  end,
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        features = 'all',
      },
      check = {
        command = 'clippy',
      },
      interpret = {
        tests = true,
      },
    },
  },
}
