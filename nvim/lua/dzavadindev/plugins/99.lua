return {
  'ThePrimeagen/99',
  config = function()
    local _99 = require '99'
    local cwd = vim.uv.cwd()
    local basename = vim.fs.basename(cwd)

    _99.setup {
      logger = {
        level = _99.DEBUG,
        path = '/tmp/' .. basename .. '.99.debug',
        print_on_error = true,
      },

      provider = _99.OpenCodeProvider,
      model = 'openai/gpt-5.2-codex',

      completion = {
        custom_rules = {
          'scratch/custom_rules/',
        },
        source = 'cmp',
      },

      md_files = {
        'AGENT.md',
      },
    }

    vim.keymap.set('v', '<leader>9v', function()
      _99.visual()
    end, { desc = '99: Visual' })

    vim.keymap.set({ 'n', 'v' }, '<leader>9s', function()
      _99.stop_all_requests()
    end, { desc = '99: Stop all requests' })
  end,
}
