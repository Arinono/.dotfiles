local nnoremap = require('arinono.keymap').nnoremap

nnoremap('<leader>ss', vim.cmd.Spotify)
nnoremap('<leader>sn', '<Plug>(SpotifySkip)')
nnoremap('<leader>sN', '<Plug>(SpotifyPrev)')
nnoremap('<leader>sp', '<Plug>(SpotifyPause)')
