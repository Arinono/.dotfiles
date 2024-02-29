local silicon = require("silicon")

silicon.setup({
	font = "Dank Mono=34;MesloLGL Nerd Font=34",
	theme = "gruvbox-dark",
	to_clipboard = true,
	no_window_controls = true,
	tab_width = 2,
	pad_horiz = 32,
	pad_vert = 16,
	background = "#24283b",
})

vim.keymap.set("v", "<leader>sc", ":Silicon<CR>", { noremap = true })
