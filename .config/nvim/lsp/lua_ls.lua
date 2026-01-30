local mason_bin = vim.fn.stdpath 'data' .. '/mason/bin/'

return {
  cmd = { mason_bin .. 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      telemetry = { enable = false },
      hint = { enable = true },
      completion = { callSnippet = 'Replace' },
      -- Let lazydev.nvim handle workspace library for Neovim runtime
      workspace = { 
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library"
        }
      },
      diagnostics = {
        globals = { 'vim' }
      }
    },
  },
}
