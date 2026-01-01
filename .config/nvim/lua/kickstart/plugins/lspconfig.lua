return {
  -- Mason for installing LSP servers and tools
  {
    'mason-org/mason.nvim',
    opts = {},
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'mason-org/mason.nvim' },
    opts = {
      ensure_installed = {
        -- LSP servers (Mason package names)
        'lua-language-server',
        'gopls',
        'pyright',
        'typescript-language-server',
        'clangd',
        'bash-language-server',
        'dockerfile-language-server',
        'rust-analyzer',
        -- Formatters/linters
        'stylua',
      },
    },
  },
  -- Useful status updates for LSP
  { 'j-hui/fidget.nvim', opts = {} },

  -- LSP setup using native vim.lsp.config/enable
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lspFun = require 'custom.lspFun'

      -- LspAttach autocmd for keymaps and buffer-local settings
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = lspFun.attach,
      })

      -- LspDetach autocmd to clean up highlight autocmds
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(args)
          pcall(vim.api.nvim_del_augroup_by_name, 'lsp-highlight-' .. args.data.client_id)
        end,
      })

      -- Global config for all LSP servers
      vim.lsp.config('*', {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
        root_markers = { '.git' },
      })

      -- Enable all configured servers (configs are in lsp/*.lua)
      vim.lsp.enable {
        'lua_ls',
        'gopls',
        'pyright',
        'ts_ls',
        'clangd',
        'bashls',
        'dockerls',
        'rust_analyzer',
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
