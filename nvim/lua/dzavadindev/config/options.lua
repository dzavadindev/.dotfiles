vim.g.have_nerd_font = true

-- default blend for new floating windows
vim.opt.winblend = 0
-- popup menu blend
vim.opt.pumblend = 0

-- Show relative line numbers
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- Raise a dialog asking if you wish to preform an operation
vim.o.confirm = true

-- Tabulation settings
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.tabstop = 4

-- Disable statusline highlighting for transparent bg
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    vim.cmd 'hi StatusLine guibg=NONE'
  end,
})

-- LSP-less formatting of .qml files

-- vim.api.nvim_create_autocmd('BufWritePost', {
--   group = vim.api.nvim_create_augroup('QmlAutoFormat', { clear = true }),
--   pattern = '*.qml',
--   callback = function(args)
--     -- Format the just-saved file in-place
--     vim.fn.jobstart({ 'qmlformat', '-i', args.file }, {
--       on_exit = function(_, code, _)
--         if code == 0 then
--           -- Reload the buffer if the file changed
--           vim.schedule(function()
--             vim.cmd('checktime ' .. vim.fn.fnameescape(args.file))
--           end)
--         else
--           vim.notify('qmlformat failed with exit code ' .. code, vim.log.levels.WARN)
--         end
--       end,
--     })
--   end,
-- })
