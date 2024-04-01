vim.diagnostic.config {
  virtual_text = {
    source = 'if_many',
  },
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = {
    reverse = true,
  },
  float = {
    source = 'always',
  },
}
