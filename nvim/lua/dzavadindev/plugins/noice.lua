return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
  config = function()
    require('noice').setup {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },

      views = {
        cmdline_popup = {
          position = {
            row = 40,
            col = '50%',
          },
          size = {
            width = 80,
            height = 'auto',
          },
          win_options = {
            winhighlight = {
              FloatBorder = 'SpecialKey',
            },
          },
        },
      },

      presets = {
        bottom_search = true,
        command_palette = true,
      },
    }
  end,
}
