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
	window_title = function()
		local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
		local dir = vim.fn.fnamemodify(bufname, ":h:t")
		local file = vim.fn.fnamemodify(bufname, ":t")
		return dir .. "/" .. file
	end,
})

vim.keymap.set("v", "<leader>sc", ":Silicon<CR>", { noremap = true })
