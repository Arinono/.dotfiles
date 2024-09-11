local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.automatically_reload_config = true
config.quit_when_all_windows_are_closed = true

config.color_scheme = "tokyonight_storm"
config.font_size = 14
config.freetype_load_flags = "NO_HINTING"
config.font = wezterm.font_with_fallback({
	{ family = "Dank Mono", weight = "Bold" },
	{ family = "MesloLGL Nerd Font", weight = "Bold" },
})

config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

return config
