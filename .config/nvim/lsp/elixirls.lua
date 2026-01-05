local mason_bin = vim.fn.stdpath 'data' .. '/mason/bin/'

return {
  cmd = { mason_bin .. 'elixir-ls' },
  filetypes = { 'elixir', 'eelixir', 'heex', 'surface' },
  root_markers = { 'mix.exs', '.git' },
  settings = {
    elixirLS = {
      dialyzerEnabled = true,
      fetchDeps = false,
      enableTestLenses = true,
      suggestSpecs = true,
    },
  },
}
