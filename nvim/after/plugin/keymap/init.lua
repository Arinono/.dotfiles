local Remap = require("arinono.keymap")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap

inoremap("<C-c>", "<esc>")
nnoremap("<leader>t", ":tabnew<cr>")
nnoremap("Q", "<nop>")

-- Neoformat
nnoremap("<leader>fmt", "<cmd>:Neoformat<cr>")

-- Files
nnoremap("<leader>e", "<cmd>Ex<cr>")

-- Edition
vnoremap("J", ":m '>+1<CR>gv=gv")
vnoremap("K", ":m '<-2<CR>gv=gv")
xnoremap("<leader>p", "\"_dP")

-- Navigation
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")
nnoremap("n", "nzz")
nnoremap("N", "Nzz")
nnoremap("G", "Gzz")

-- Commands
nnoremap("<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
nnoremap("<leader>nox", "<cmd>!chmod -x %<CR>", { silent = true })
