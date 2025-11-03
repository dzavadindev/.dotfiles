return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local custom_theme = require 'lualine.themes.auto'
      custom_theme.normal.c.bg = 'None'
      require('lualine').setup {
        options = {
          disabled_filetypes = {
            statusline = {
              'neo-tree',
            },
          },
          theme = custom_theme,
        },
        sections = {
          lualine_a = {
            {
              'mode',
              fmt = function(mode)
                return mode:sub(1, 1)
              end,
            },
          },
          lualine_b = {
            'branch',
            'diagnostics',
            {
              function()
                return vim.g.remote_neovim_host and ('Remote: %s'):format(vim.uv.os_gethostname()) or ''
              end,
              padding = { right = 1, left = 1 },
              separator = { left = '', right = '' },
            },
          },
          lualine_c = { 'filename' },
          lualine_y = { 'lsp_status' },
          lualine_z = { 'progress', 'location' },
        },
      }
    end,
  },
}
