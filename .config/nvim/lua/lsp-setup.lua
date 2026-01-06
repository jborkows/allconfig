-- Native LSP setup for Neovim 0.11+
-- No nvim-lspconfig dependency required

local lspFun = require 'custom.lspFun'

-- LspAttach autocmd for keymaps and buffer-local settings
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('native-lsp-attach', { clear = true }),
  callback = lspFun.attach,
})

-- LspDetach autocmd to clean up highlight autocmds
vim.api.nvim_create_autocmd('LspDetach', {
  group = vim.api.nvim_create_augroup('native-lsp-detach', { clear = true }),
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
  'elixirls',
}
