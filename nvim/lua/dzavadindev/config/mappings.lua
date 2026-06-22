-- jj to quit the insert mode
vim.keymap.set('i', 'jj', '<Esc>', { noremap = false })

-- Unmap the arrow keys in normal mode (pain)
vim.keymap.set('n', '<Left>', '<cmd>Use h<CR>')
vim.keymap.set('n', '<Right>', '<cmd>Use l<CR>')
vim.keymap.set('n', '<Down>', '<cmd>Use j<CR>')
vim.keymap.set('n', '<Up>', '<cmd>Use k<CR>')

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Close buffer
vim.keymap.set('n', '<C-c>', '<cmd>w | bp | bd #<CR>', { desc = '[Q]uit currently focused buffer' })

-- Save
vim.keymap.set('n', '<C-s>', '<cmd>w<CR>', { desc = '[W]rite file' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
