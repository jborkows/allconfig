-- Highlight todo, notes, etc in comments
return {
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = true },
    init = function()
      require('todo-comments').setup {
        keywords = {
          FIX = {
            icon = ' ', -- icon used for the sign, and in search results
            color = 'error', -- can be a hex color, or a named color (see below)
            alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' }, -- a set of other keywords that all map to this FIX keywords
            -- signs = false, -- configure signs for some keywords individually
          },
          TODO = { icon = ' ', color = 'info' },
          HACK = { icon = ' ', color = 'warning' },
        },
        -- more configuration options here
      }

      -- @param {OPENED|CLOSED} state
      local state = 'CLOSED'

      local function toggleQuickfix()
        if state == 'OPENED' then
          vim.cmd 'cclose'
          state = 'CLOSED'
        else
          local ok, result = pcall(function()
            vim.cmd 'TodoQuickFix'
          end)
          if ok then
            state = 'OPENED'
          end
        end
      end

      vim.keymap.set('n', 't', toggleQuickfix, { noremap = true, silent = true, desc = 'Toggle todo quickfix' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
