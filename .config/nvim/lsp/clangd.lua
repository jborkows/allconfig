local mason_bin = vim.fn.stdpath 'data' .. '/mason/bin/'

return {
  cmd = { mason_bin .. 'clangd' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
  root_markers = { '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt', '.git' },
}
