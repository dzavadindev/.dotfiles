return {
  'VonHeikemen/fine-cmdline.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  config = function()
    vim.api.nvim_set_keymap('n', ':', '<cmd>FineCmdline<CR>', { noremap = true })
    require('fine-cmdline').setup {
      popup = {
        position = {
          row = '90%',
          col = '50%',
        },
      },
    }
  end,
}
