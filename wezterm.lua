local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.default_prog = { "powershell.exe" }
config.initial_cols = 120
config.initial_rows = 28
config.font_size = 10

-- Define Osaka Jade color scheme
config.color_schemes = {
  ["Osaka Jade"] = {
    foreground = "#F7E8B2",
    background = "#111c18",
    cursor_bg = "#E67D64",
    cursor_border = "#E67D64",
    cursor_fg = "#111c18",
    selection_bg = "#364538",
    selection_fg = "#DEB266",

    ansi = {
      "#23372B", -- black
      "#FF5345", -- red
      "#549E6A", -- green
      "#E1B55E", -- yellow
      "#75BBB3", -- blue (muted cyan tone)
      "#D2689C", -- magenta
      "#2DD5B7", -- cyan
      "#F6F5DD", -- white
    },
    brights = {
      "#53685B", -- bright black
      "#DB9F9C", -- bright red
      "#63B07A", -- bright green
      "#E5C736", -- bright yellow
      "#ACD4CF", -- bright blue
      "#75BBB3", -- bright magenta substitute
      "#8CD3CB", -- bright cyan
      "#9EEBB3", -- bright white
    },

    compose_cursor = "#81B8A8",
    scrollbar_thumb = "#364538",
    split = "#81B8A8",
  },
}

-- Apply the Osaka Jade scheme
config.color_scheme = "Osaka Jade"

-- Optional subtle gradient background to echo the VS theme
config.window_background_gradient = {
  colors = { "#111c18", "#23372B" },
  orientation = { Linear = { angle = -45.0 } },
}

config.text_background_opacity = 1
config.window_background_opacity = 0.94

return config
