local nnoremap = require("arinono.keymap").nnoremap

nnoremap("<leader>z", function()
	require("centerpad").toggle({
		leftpad = 69,
		rightpad = 69,
	})
end)
