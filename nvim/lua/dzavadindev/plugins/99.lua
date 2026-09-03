return {
  'ThePrimeagen/99',
  config = function()
    local _99 = require '99'
    local cwd = vim.uv.cwd()
    local basename = vim.fs.basename(cwd)
    local opencode = vim.fn.exepath 'opencode2'

    if opencode == '' then
      opencode = vim.fn.exepath 'opencode'
    end

    local provider = setmetatable({
      _build_command = function(_, query, context)
        return {
          opencode,
          'run',
          '--print-logs',
          '--log-level',
          'all',
          '--agent',
          '99',
          '-m',
          context.model,
          query,
        }
      end,
    }, {
      __index = function(_, key)
        return _99.Providers.OpenCodeProvider[key] or _99.Providers.BaseProvider[key]
      end,
    })

    _99.setup {
      logger = {
        type = 'file',
        level = _99.DEBUG,
        path = vim.fn.stdpath 'state' .. '/99.log',
        print_on_error = true,
      },

      provider = provider,
      model = 'openai/gpt-5.6-luna-fast',

      completion = {
        custom_rules = {
          'scratch/custom_rules/',
        },
        source = 'cmp',
      },

      tmp_dir = '/tmp/99-state',

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
