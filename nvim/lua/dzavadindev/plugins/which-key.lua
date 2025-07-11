return {
  {
    'folke/which-key.nvim', -- Show pending keybinds.
    event = 'VimEnter',
    opts = {
      preset = 'helix',
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
      },
      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },
}
