-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.
config.default_prog = { "powershell.exe" }
-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 10
config.color_scheme = "AdventureTime"
config.window_background_gradient = {
	colors = { "#2d0734", "#26083f" },
	-- Specifies a Linear gradient starting in the top left corner.
	orientation = { Linear = { angle = -45.0 } },
}
config.text_background_opacity = 1
config.window_background_opacity = 0.95
-- Finally, return the configuration to wezterm:
return config
