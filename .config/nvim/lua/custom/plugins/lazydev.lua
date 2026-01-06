return {
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        -- Load Neovim runtime
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        -- Add Neovim runtime for vim.* completions
        { path = vim.env.VIMRUNTIME .. '/lua' },
        { path = vim.fn.stdpath 'config' .. '/lua' },
      },
    },
  },
  -- Optional: luvit types for vim.uv
  { 'Bilal2453/luvit-meta', lazy = true },
}
