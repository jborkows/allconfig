local mason_bin = vim.fn.stdpath 'data' .. '/mason/bin/'

return {
  cmd = { mason_bin .. 'sqls' },
  filetypes = { 'sql' },
  root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
}
