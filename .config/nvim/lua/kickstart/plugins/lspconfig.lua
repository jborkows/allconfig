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
}
-- vim: ts=2 sts=2 sw=2 et
