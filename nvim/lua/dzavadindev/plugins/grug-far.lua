return {
  'MagicDuck/grug-far.nvim',
  config = function()
    local grug = require 'grug-far'
    vim.keymap.set('n', '<localleader>sr', function()
      grug.open()
    end, { desc = 'grug-far: [S]earch and [R]eplace' })
  end,
}
