vim.keymap.set("n", "<leader><leader>", "<cmd>so<CR>", { desc = "[S]hout [O]ut" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", function()
  vim.diagnostic.goto_prev()
  vim.cmd("normal! zz")
end, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", function()
  vim.diagnostic.goto_next()
  vim.cmd("normal! zz")
end, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>doo", function()
  vim.diagnostic.open_float()
end, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set(
  "n",
  "<leader>doq",
  vim.diagnostic.setloclist,
  { desc = "Open diagnostic [Q]uickfix list" }
)

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("i", "<C-c>", "<esc>")
vim.keymap.set("n", "<leader>t", ":tabnew<cr>", { desc = "New tab" })
vim.keymap.set("n", "Q", "<nop>")

-- Edition
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("v", "{", "{j")
vim.keymap.set("v", "}", "}k")
vim.keymap.set("n", "<leader>V", "{jV}k", { desc = "[V]isual line paragraph" })

-- Navigation
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "G", "Gzz")
vim.keymap.set("n", "<leader>zz", "zszH")
vim.keymap.set("n", "]c", "]czz")
vim.keymap.set("n", "[c", "[czz")
vim.keymap.set("n", "<BS>", "<cmd>b#<cr>")

-- Crossyank
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

-- Commands
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<leader>nox", "<cmd>!chmod -x %<CR>", { silent = true })
