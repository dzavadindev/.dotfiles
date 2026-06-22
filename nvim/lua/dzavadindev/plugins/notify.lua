return {
  'rcarriga/nvim-notify',
  config = function()
    require('notify').setup {
      merge_duplicates = true,

      background_colour = 'NormalFloat',
      fps = 60,
      render = 'wrapped-compact',
      max_width = 45,
      stages = 'slide',
      timeout = 2500,
    }
  end,
}
