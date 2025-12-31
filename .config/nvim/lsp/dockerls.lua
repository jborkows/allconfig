local mason_bin = vim.fn.stdpath 'data' .. '/mason/bin/'

return {
  cmd = { mason_bin .. 'docker-langserver', '--stdio' },
  filetypes = { 'dockerfile' },
  root_markers = { 'Dockerfile', '.git' },
}
