return {
  {
    'tpope/vim-fugitive',
    cmd = {
      'Git',
      'G',
      'Gdiffsplit',
      'Gvdiffsplit',
      'Gread',
      'Gwrite',
      'Gclog',
      'Gblame',
    },
    keys = {
      { '<leader>gs', '<cmd>Git<cr>', desc = 'git [s]tatus' },
      { '<leader>gd', '<cmd>Gvdiffsplit!<cr>', desc = 'git [d]iff split' },
      { '<leader>gb', '<cmd>Git blame<cr>', desc = 'git [b]lame' },
    },
    config = function()
      local function attach_fugitive_diff_maps(bufnr)
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Only add these mappings in actual diff buffers
        if not vim.wo.diff then
          return
        end

        map('n', '<leader>gh', '<cmd>diffget //2<cr>', { desc = 'git: take hunk from left' })
        map('n', '<leader>gl', '<cmd>diffget //3<cr>', { desc = 'git: take Hunk from right' })
        map('n', '<leader>gp', '<cmd>diffput<cr>', { desc = 'git [p]ut current hunk' })

        -- Nice extras
        map('n', ']x', ']c', { desc = 'jump to next conflict/change' })
        map('n', '[x', '[c', { desc = 'jump to previous conflict/change' })
        map('n', '<leader>gq', '<cmd>diffoff!<cr>', { desc = 'git quit diff mode' })
      end

      vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
        callback = function(args)
          if vim.wo.diff then
            attach_fugitive_diff_maps(args.buf)
          end
        end,
      })
    end,
  },
}
