-- custom/configs/completion.lua - vim.snippet + blink.cmp integration
-- Note: Most configuration is now handled in the main blink.cmp config
-- This file can contain additional completion-related configurations

-- SQL completion with vim-dadbod-completion is now handled in the main blink.cmp config
-- The dadbod provider is automatically available for sql, mysql, plsql filetypes

-- Use vim.snippet for snippet navigation
vim.keymap.set({ 'i', 's' }, '<M-d>', function()
  if vim.snippet.active { direction = 1 } then
    vim.snippet.jump(1)
  end
end, { desc = 'Jump to next snippet placeholder' })

vim.keymap.set({ 'i', 's' }, '<M-s>', function()
  if vim.snippet.active { direction = -1 } then
    vim.snippet.jump(-1)
  end
end, { desc = 'Jump to previous snippet placeholder' })
