return {
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      local db = require 'dashboard'

      db.setup {
        theme = 'hyper',
        config = {
          header = {
            ' ',
            '  ███╗   ██╗██╗   ██╗██╗███╗   ███╗',
            '  ████╗  ██║██║   ██║██║████╗ ████║',
            '  ██╔██╗ ██║██║   ██║██║██╔████╔██║',
            '  ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║',
            '  ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║',
            '  ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝',
            ' ',
          },

          shortcut = {
            {
              icon = ' ',
              desc = 'Open dotfiles',
              group = '@property',
              key = 'd',
              action = 'Telescope find_files cwd=~/.dotfiles',
            },
            {
              icon = ' ',
              desc = 'Open Quickshell config',
              group = '@property',
              key = 'q',
              action = 'Telescope find_files cwd=~/.dotfiles/quickshell',
            },
          },

          project = {
            enable = true,
            limit = 8,
            icon = ' ',
            label = ' Projects',
            action = 'Telescope find_files cwd=',
          },
        },
      }
    end,
  },
}
