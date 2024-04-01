local M = {}

M.keys = {
  {
    '<leader>f',
    function()
      require('conform').format { async = true, lsp_fallback = true }
    end,
    mode = '',
    desc = '[F]ormat buffer',
  },
}

M.disabled = {
  c = true,
  cpp = true,
  js = true,
  ts = true,
  vue = true,
}

M.formatters = {
  lua = { 'stylua' },
  js = { 'prettier' },
  ts = { 'prettier' },
  vue = { 'prettier' },
}

return M
