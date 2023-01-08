vim.opt.guicursor = ""
vim.opt.mouse = ""

vim.opt.relativenumber = true
vim.opt.nu = true

vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.updatetime = 50

vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = {80, 100}
vim.opt.termguicolors = true

vim.opt.encoding = "utf-8"

vim.g.netrw_banner = 0

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

vim.g.mapleader = " "
