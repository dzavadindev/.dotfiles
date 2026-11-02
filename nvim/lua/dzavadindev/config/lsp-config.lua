return {
  {
    -- `lazydev` improves Lua LS completion/signatures for Neovim config/runtime APIs
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  {
    -- Main LSP configuration
    'neovim/nvim-lspconfig',

    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      { 'j-hui/fidget.nvim', opts = { notification = { window = { winblend = 0 } } } },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- nvim-cmp core (completion UI/engine)
      'hrsh7th/nvim-cmp',

      'hrsh7th/cmp-nvim-lsp',
    },

    config = function()
      ---------------------------------------------------------------------------
      -- Keymaps & small LSP UX niceties (runs when an LSP attaches to a buffer)
      ---------------------------------------------------------------------------
      local lsp_attach = vim.api.nvim_create_augroup('dzavadindev-lsp-attach', { clear = true })
      local lsp_detach = vim.api.nvim_create_augroup('dzavadindev-lsp-detach', { clear = true })
      local lsp_highlight = vim.api.nvim_create_augroup('dzavadindev-lsp-highlight', { clear = true })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = lsp_attach,
        callback = function(event)
          -- Helper for defining buffer-local LSP keymaps
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[G]oto [R]e[n]ame')
          map('gca', vim.lsp.buf.code_action, '[G]oto [C]ode [A]ction', { 'n', 'x' })
          map('K', vim.lsp.buf.hover, 'Hover Do[K]umentation')

          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open D[O]cument Symbols')
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open [W]orkspace Symbols')
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- Highlight symbol under cursor if server supports it
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = lsp_highlight,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = lsp_highlight,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = lsp_detach,
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = lsp_highlight, buffer = event2.buf }
              end,
            })
          end

          -- Toggle inlay hints if supported
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      ---------------------------------------------------------------------------
      -- Diagnostics UI configuration
      ---------------------------------------------------------------------------
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            return diagnostic.message
          end,
        },
      }

      ---------------------------------------------------------------------------
      -- LSP capabilities
      ---------------------------------------------------------------------------

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      ---------------------------------------------------------------------------
      -- Language servers
      ---------------------------------------------------------------------------
      local servers = {
        rust_analyzer = {},
        clangd = {},
        arduino_language_server = {},
        pylsp = {},

        qmlls = {
          on_attach = function(client, bufnr)
            -- Stop qmlls from publishing diagnostics (Quickshell ~_~)
            client.handlers['textDocument/publishDiagnostics'] = function() end

            -- Clear any diagnostics it may have already sent during initialize
            local get_ns = vim.lsp.diagnostic and vim.lsp.diagnostic.get_namespace
            local ns = get_ns and vim.lsp.diagnostic.get_namespace(client.id) or nil
            if ns then
              pcall(vim.diagnostic.reset, ns, bufnr)
            else
              pcall(vim.diagnostic.reset, nil, bufnr)
            end
          end,
        },

        omnisharp = {
          cmd = {
            'dotnet',
            vim.fn.stdpath 'data' .. '/mason/packages/omnisharp/libexec/OmniSharp.dll',
          },
          settings = {
            omnisharp = {
              useModernNet = true,
            },
          },
        },

        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      ---------------------------------------------------------------------------
      -- Ensure tools/servers installed via Mason
      ---------------------------------------------------------------------------
      local ensure_installed = vim.tbl_keys(servers or {})

      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      ---------------------------------------------------------------------------
      -- Install and enable language servers
      ---------------------------------------------------------------------------
      require('mason-lspconfig').setup {
        ensure_installed = {}, -- Kickstart uses mason-tool-installer above
        automatic_installation = false,
      }

      for server_name, server in pairs(servers) do
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        vim.lsp.config(server_name, server)
        vim.lsp.enable(server_name)
      end
    end,
  },
}
