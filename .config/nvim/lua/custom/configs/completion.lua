-- custom/configs/completion.lua - vim.snippet + blink.cmp integration
-- Note: Most configuration is now handled in the main blink.cmp config
-- This file can contain additional completion-related configurations

-- SQL completion with vim-dadbod-completion is now handled in the main blink.cmp config
-- The dadbod provider is automatically available for sql, mysql, plsql filetypes

-- Snippet navigation is handled by blink.cmp keymaps:
--   <Tab>   -> next snippet placeholder / next completion item / literal tab
--   <S-Tab> -> previous snippet placeholder / previous completion item
