vim.g.copilot_no_tabs_map = true
vim.keymap.set(
	"i",
	"<C-M>",
	'copilot#Accept("<CR>")',
	{ silent = true, expr = true, noremap = true, replace_keycodes = false }
)
