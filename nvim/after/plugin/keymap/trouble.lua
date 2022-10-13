local nnoremap = require('arinono.keymap').nnoremap

nnoremap('<leader>xl', "<cmd>call coc#rpc#request('fillDiagnostics', [bufnr('%')])<cr><cmd>TroubleToggle loclist<cr>")
