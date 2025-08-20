-- custom/configs/completion.lua - Converted to use blink.cmp
-- Note: Most configuration is now handled in the blink.cmp plugin setup
-- This file can contain additional completion-related configurations

-- Load custom snippets (preserved from your original config)
for _, ft_path in pairs(vim.api.nvim_get_runtime_file('lua/custom/snppets/*.lua', true)) do
  loadfile(ft_path)()
end

-- SQL completion with vim-dadbod-completion is now handled in the main blink.cmp config
-- The dadbod provider is automatically available for sql, mysql, plsql filetypes

-- Alternative: Use vim.snippet for navigation (recommended with blink.cmp)
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

-- Optional: Configure additional snippet behavior if you want to keep LuaSnip
--[[
local luasnip = require('luasnip')
luasnip.config.setup({
  -- Your LuaSnip configuration here if you want to keep it alongside blink.cmp
  -- Note: blink.cmp can work with both LuaSnip and vim.snippet
})

-- Custom LuaSnip keymaps (if you want to keep the exact same navigation)
vim.keymap.set({ 'i', 's' }, '<M-d>', function()
  if luasnip.expand_or_locally_jumpable() then
    luasnip.expand_or_jump()
  end
end, { desc = 'Jump to next snippet placeholder' })

vim.keymap.set({ 'i', 's' }, '<M-s>', function()
  if luasnip.locally_jumpable(-1) then
    luasnip.jump(-1)
  end
end, { desc = 'Jump to previous snippet placeholder' })
--]]
