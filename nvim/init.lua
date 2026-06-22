vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

require 'dzavadindev.config.options'
require 'dzavadindev.config.mappings'

-- Highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ --------------- Install `lazy.nvim` plugin manager  --------------- ]]

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[  --------------- Configure and install plugins  --------------- ]]
require('lazy').setup {
  -- Fine command line
  -- Detect tabstop and shiftwidth automatically
  'NMAC427/guess-indent.nvim',
  -- Nice indents for code blocks
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      require('ibl').setup {
        exclude = {
          filetypes = {
            'dashboard',
          },
        },
      }
    end,
  },
  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  -- Vivify intergation for .md files
  { 'jannis-baum/vivify.vim' },
  -- A bunch of nice little things
  {
    'echasnovski/mini.nvim',
    version = '*',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      require('mini.bufremove').setup()
    end,
  },

  require 'dzavadindev.config.lsp-config',

  -- My color scheme
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000, -- Load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('gruvbox').setup {
        transparent_mode = true,
        terminal_colors = true,
        overrides = {
          ['@comment'] = { fg = '#836953' },
          ['NormalFloat'] = { bg = require('gruvbox').palette.dark0_soft },
        },
      }
      vim.cmd.colorscheme 'gruvbox'
    end,
  },

  -- Rest of the plugins
  { import = 'dzavadindev.plugins' },
}

-- vim: ts=2 sts=2 sw=2 et
