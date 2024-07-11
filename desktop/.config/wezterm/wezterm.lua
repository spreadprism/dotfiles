local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

config.window_close_confirmation = "NeverPrompt"

-- # Appearance
config.color_scheme = "Tokyo Night Storm"
config.window_background_opacity = 0.7
config.enable_tab_bar = false
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
-- Fonts
config.font = wezterm.font("JetBrains Mono", { weight = "DemiBold" })
config.font_size = 14

-- # Keybinds
config.keys = {
	-- paste from the clipboard
	{ key = "Insert", mods = "SHIFT", action = act.PasteFrom("Clipboard") },
}

return config
