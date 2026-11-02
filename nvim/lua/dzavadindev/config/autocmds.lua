local highlight_yank = vim.api.nvim_create_augroup('dzavadindev-highlight-yank', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanked text',
  group = highlight_yank,
  callback = vim.hl.on_yank,
})

local transparent_statusline = vim.api.nvim_create_augroup('dzavadindev-transparent-statusline', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  group = transparent_statusline,
  callback = function()
    vim.cmd 'hi StatusLine guibg=NONE'
  end,
})
