return {
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- icons
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim', -- used by the actions below
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

          -- Shortcut row (press 'd' to jump into your dotfiles)
          shortcut = {
            {
              icon = ' ',
              desc = 'Open ~/.dotfiles',
              group = '@property',
              key = 'd',
              action = 'Telescope find_files cwd=~/.dotfiles',
            },
          },

          -- Recent projects/directories (clickable)
          -- Dashboard will append the project path to the action below.
          project = {
            enable = true,
            limit = 8,
            icon = ' ',
            label = ' Projects',
            action = 'Telescope find_files cwd=',
          },

          -- You can enable MRU later if you want recent files as well:
          -- mru = { limit = 10, icon = " ", label = " Recent files", cwd_only = false },
        },
      }
    end,
  },
}
