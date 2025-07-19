-- jj to quit the insert mode
vim.keymap.set('i', 'jj', '<Esc>', { noremap = false })

-- Move end-of-line and start-of-line
vim.keymap.set({ 'n', 'v' }, 'E', '$') -- end
vim.keymap.set('n', 'dE', 'd$') -- delete until the end of line

vim.keymap.set({ 'n', 'v' }, 'B', '^') -- start
vim.keymap.set('n', 'dB', 'd0') -- delete until the start

-- Unmap the arrow keys in normal mode (pain)
vim.keymap.set('n', '<Left>', '<cmd>Use h<CR>')
vim.keymap.set('n', '<Right>', '<cmd>Use l<CR>')
vim.keymap.set('n', '<Down>', '<cmd>Use j<CR>')
vim.keymap.set('n', '<Up>', '<cmd>Use k<CR>')

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
