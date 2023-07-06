local nnoremap = require("arinono.keymap").nnoremap

local current = vim.api.nvim_exec("colorscheme", true)

local function toggle()
	local day = "tokyonight-day"
	local night = "tokyonight"
	print(current)

	if current == night then
		vim.cmd("colorscheme " .. day)
		current = day
	else
		vim.cmd("colorscheme " .. night)
		current = night
	end
end

nnoremap("<leader>\\", function()
	toggle()
end)
