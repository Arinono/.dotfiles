local Remap = require("arinono.keymap")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap
local nmap = Remap.nmap

inoremap("<C-c>", "<esc>")

-- Neoformat
nnoremap("<leader>fmt", "<cmd>:Neoformat<cr>")

-- Files
nnoremap("<leader>e", "<cmd>Ex<cr>")

-- Edition
vnoremap("J", ":m '>+1<CR>gv=gv")
vnoremap("K", ":m '<-2<CR>gv=gv")

-- Commands
nnoremap("<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
nnoremap("<leader>nox", "<cmd>!chmod -x %<CR>", { silent = true })
