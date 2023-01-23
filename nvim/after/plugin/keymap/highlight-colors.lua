local nnoremap = require('arinono.keymap').nnoremap

nnoremap('<leader>ct', function()
  require('nvim-highlight-colors').toggle()
end)
