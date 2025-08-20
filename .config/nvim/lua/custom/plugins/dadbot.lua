-- Example vim-dadbod-ui configuration with blink.cmp support
-- Add this to your plugins if you're using vim-dadbod
return {
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      {
        'kristijanhusak/vim-dadbod-completion',
        ft = { 'sql', 'mysql', 'plsql' },
        lazy = true,
      },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_force_echo_notifications = 1
      vim.g.db_ui_win_position = 'left'
      vim.g.db_ui_winwidth = 30
      -- Optional: Custom completion mark
      vim.g.vim_dadbod_completion_mark = '[DB]'
      -- Optional: Set up database connections
      -- vim.g.dbs = {
      --   dev = 'postgresql://user:pass@localhost:5432/dev_db',
      --   staging = 'postgresql://user:pass@localhost:5432/staging_db',
      -- }
    end,
  },
}
