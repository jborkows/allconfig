return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    init = function()
      local ensureInstalled = { 'bash', 'c', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc', 'go', 'rust' }

      local alreadyInstalled = require('nvim-treesitter.config').get_installed()
      local parsersToInstall = vim
        .iter(ensureInstalled)
        :filter(function(parser)
          return not vim.tbl_contains(alreadyInstalled, parser)
        end)
        :totable()
      require('nvim-treesitter').install(parsersToInstall)

      local treesitter_group = vim.api.nvim_create_augroup('treesitter-group', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'go', 'bash', 'sh', 'lua', 'md', 'rs' },
        group = treesitter_group,
        callback = function()
          vim.treesitter.start()
        end,
      })
      vim.api.nvim_create_user_command('FoldAll', function()
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo[0][0].foldmethod = 'expr'
      end, {})

      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.opt.foldminlines = 10
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
