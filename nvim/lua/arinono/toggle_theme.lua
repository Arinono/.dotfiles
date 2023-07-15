local nnoremap = require("arinono.keymap").nnoremap

local current = vim.api.nvim_exec("colorscheme", true)

local function toggle()
	local day = "tokyonight-day"
	local night = "tokyonight"

	if current == day then
		vim.cmd("colorscheme " .. night)
		current = night
	else
		vim.cmd("colorscheme " .. day)
		current = day
	end
end

nnoremap("<leader>\\", function()
	toggle()
end)
