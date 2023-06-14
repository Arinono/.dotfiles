local nnoremap = require("arinono.keymap").nnoremap

nnoremap("<leader>ph", ":Telescope harpoon marks<cr>")

nnoremap("<leader>hh", function()
	require("harpoon.ui").toggle_quick_menu()
end)

nnoremap("<leader>hg", function()
	require("harpoon.mark").add_file()
end)

nnoremap("<leader>hn", function()
	require("harpoon.ui").nav_next()
end)

nnoremap("<leader>hp", function()
	require("harpoon.ui").nav_prev()
end)

nnoremap("<leader>ha", function()
	require("harpoon.ui").nav_file(1)
end)

nnoremap("<leader>hs", function()
	require("harpoon.ui").nav_file(2)
end)

nnoremap("<leader>hd", function()
	require("harpoon.ui").nav_file(3)
end)

nnoremap("<leader>hf", function()
	require("harpoon.ui").nav_file(4)
end)
