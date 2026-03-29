-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

local function ensure_spell_files()
  local spell_dir = vim.fn.stdpath 'data' .. '/site/spell'
  local pl_spl = spell_dir .. '/pl.utf-8.spl'

  if vim.fn.isdirectory(spell_dir) == 0 then
    vim.fn.mkdir(spell_dir, 'p')
  end

  if vim.fn.filereadable(pl_spl) == 0 then
    vim.system({
      'wget',
      '--no-check-certificate',
      'https://ftp.vim.org/vim/runtime/spell/pl.utf-8.spl',
      '-P',
      spell_dir,
    }, { text = true }, function(obj)
      if obj.code == 0 then
        vim.schedule(function()
          vim.notify('Polish spellfile downloaded ✅', vim.log.levels.INFO)
        end)
      else
        vim.schedule(function()
          vim.notify('Failed to download spellfile ❌', vim.log.levels.ERROR)
        end)
      end
    end)
  end
end
-- Call the function to ensure the spell files are installed
vim.api.nvim_create_autocmd('VimEnter', {
  callback = ensure_spell_files,
})

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10
vim.opt.termguicolors = true
vim.opt.spell = true
vim.opt.spelllang = 'en_us,pl'

vim.o.exrc = true
-- vim: ts=2 sts=2 sw=2 et
