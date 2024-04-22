vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

vim.g.netrw_banner = 0

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

vim.opt.mouse = ""
vim.opt.guicursor = ""

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.opt.clipboard = 'unnamedplus'

vim.opt.breakindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"
vim.opt.updatetime = 10
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.wrap = false
vim.opt.cursorline = true

-- mainly for md and obsidian support
vim.opt.conceallevel = 2

vim.opt.colorcolumn = { 80, 100 }
vim.opt.termguicolors = true
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
