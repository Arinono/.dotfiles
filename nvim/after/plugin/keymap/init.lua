local Remap = require("arinono.keymap")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap

inoremap("<C-c>", "<esc>")
nnoremap("<leader>t", ":tabnew<cr>")
nnoremap("Q", "<nop>")

-- Neoformat
nnoremap("<leader>f", function()
	vim.lsp.buf.format()
end)

-- Files
nnoremap("<leader>e", "<cmd>Ex<cr>")

-- Edition
vnoremap("J", ":m '>+1<CR>gv=gv")
vnoremap("K", ":m '<-2<CR>gv=gv")
xnoremap("<leader>p", '"_dP')
nnoremap("J", "mzJ`z")

nnoremap("<leader>'", "ciw'<C-r>\"'<esc>")
nnoremap("<leader>;'", "di'hPl2x")

-- Navigation
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")
nnoremap("n", "nzz")
nnoremap("N", "Nzz")
nnoremap("G", "Gzz")

-- Crossyank
nnoremap("<leader>y", '"+y')
vnoremap("<leader>y", '"+y')
nnoremap("<leader>Y", '"+Y')

-- Commands
nnoremap("<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
nnoremap("<leader>nox", "<cmd>!chmod -x %<CR>", { silent = true })
