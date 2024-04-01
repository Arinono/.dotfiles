local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local arinono_group = augroup('Arinono', {})
local yank_group = augroup('HighlightYank', {})

autocmd({ 'BufWritePre' }, {
  group = arinono_group,
  pattern = '*',
  command = [[%s/\s\+$//e]],
})

autocmd('TextYankPost', {
  group = yank_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank {
      higroup = 'IncSearch',
      timeout = 40,
    }
  end,
})
