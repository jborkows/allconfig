-- kickstart/plugins/cmp.lua converted to blink.cmp
return {
  'saghen/blink.cmp',
  lazy = false, -- lazy loading handled internally
  dependencies = {
    -- LuaSnip integration if you want to keep using it
    -- Note: blink.cmp has native snippet support via vim.snippet
    -- 'L3MON4D3/LuaSnip',
    -- 'saadparwaiz1/cmp_luasnip', -- not needed with blink.cmp
  },
  version = 'v0.*',

  -- Custom keymap configuration matching your original nvim-cmp setup
  opts = function(_, opts)
    opts.keymap = {
      preset = 'none', -- We'll define custom keymaps
      -- Tab jumps snippet placeholders first, then completion items, then literal tab
      ['<Tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
      ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      ['<M-a>'] = { 'accept', 'fallback' }, -- Your original confirm mapping
      ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    }

    opts.appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
      kind_icons = {
        Text = '󰉿',
        Method = '󰆧',
        Function = '󰊕',
        Constructor = '',
        Field = '󰜢',
        Variable = '󰀫',
        Class = '󰠱',
        Interface = '',
        Module = '',
        Property = '󰜢',
        Unit = '󰑭',
        Value = '󰎠',
        Enum = '',
        Keyword = '󰌋',
        Snippet = '',
        Color = '󰏘',
        File = '󰈙',
        Reference = '󰈇',
        Folder = '󰉋',
        EnumMember = '',
        Constant = '󰏿',
        Struct = '󰙅',
        Event = '',
        Operator = '󰆕',
        TypeParameter = '',
      },
    }

    opts.sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      -- File-type specific sources to match your original config
      per_filetype = {
        sql = { 'snippets', 'dadbod', 'buffer' },
        mysql = { 'snippets', 'dadbod', 'buffer' },
        plsql = { 'snippets', 'dadbod', 'buffer' },
      },
      providers = {
        dadbod = {
          name = 'Dadbod',
          module = 'vim_dadbod_completion.blink',
          -- Only show in SQL file types
          enabled = function(ctx)
            if not ctx or not ctx.bufnr then
              -- When ctx is nil, check current buffer filetype
              return vim.tbl_contains({ 'sql', 'mysql', 'plsql' }, vim.bo.filetype)
            end
            return vim.tbl_contains({ 'sql', 'mysql', 'plsql' }, vim.bo[ctx.bufnr].filetype)
          end,
        },
      },
    }

    opts.completion = {
      trigger = {
        show_in_snippet = true,
        show_on_keyword = true,
        show_on_trigger_character = true,
        show_on_blocked_trigger_characters = { ' ', '\n', '\t' },
      },
      list = {
        max_items = 200,
        selection = {
          preselect = true,    -- Matches 'noinsert' behavior
          auto_insert = false, -- Matches 'noinsert' behavior
        },
      },
      accept = {
        create_undo_point = true,
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        enabled = true,
        min_width = 15,
        max_height = 10,
        border = 'none',
        winblend = vim.o.pumblend,
        winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
        auto_show = true,
        -- Configure to match nvim-cmp behavior
        draw = {
          columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
          align_to = 'label',
          padding = 1,
          gap = 1,
          treesitter = { 'lsp' },
        },
      },

      documentation = {
        auto_show = false,
        auto_show_delay_ms = 500,
        update_delay_ms = 50,
        treesitter_highlighting = true,
        window = {
          max_width = 80,
          max_height = 20,
          border = 'none',
          winblend = vim.o.pumblend,
          winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder',
        },
      },

      ghost_text = {
        enabled = false,
      },
    }

    -- Use vim.snippet instead of LuaSnip for better integration
    opts.snippets = {
      expand = function(snippet)
        vim.snippet.expand(snippet)
      end,
      active = function(filter)
        return vim.snippet.active(filter)
      end,
      jump = function(direction)
        vim.snippet.jump(direction)
      end,
    }

    opts.signature = {
      enabled = true,
    }

    return opts
  end,

  config = function(_, opts)
    require('blink.cmp').setup(opts)

    -- Load custom snippets if they exist (matching your original config)
    for _, ft_path in pairs(vim.api.nvim_get_runtime_file('lua/custom/snippets/*.lua', true)) do
      loadfile(ft_path)()
    end

    -- If you want to keep LuaSnip integration for custom navigation
    -- Uncomment and adjust this section:
    --[[
    local luasnip = require('luasnip')
    vim.keymap.set({ 'i', 's' }, '<M-d>', function()
      if luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      end
    end)
    vim.keymap.set({ 'i', 's' }, '<M-s>', function()
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      end
    end)
    --]]
  end,
}
