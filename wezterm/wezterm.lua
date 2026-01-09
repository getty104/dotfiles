-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- or, changing the font size and color scheme.
config.font_size = 11
config.color_scheme = "Monokai Remastered"
config.automatically_reload_config = true
config.scrollback_lines = 10000
config.use_ime = true
config.window_background_opacity = 0.6
config.font = wezterm.font_with_fallback({
  { family = "Hack Nerd Font Mono", weight = "Bold" },
  { family = "Hiragino Sans", weight = "DemiBold" },
})

config.keys = {
  {
    key = "f",
    mods = "CTRL|CMD",
    action = wezterm.action.ToggleFullScreen,
  },
}

config.adjust_window_size_when_changing_font_size = true
config.check_for_updates = true
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Start in fullscreen mode
local mux = wezterm.mux
wezterm.on("gui-startup", function(window)
  local tab, pane, window = mux.spawn_window(cmd or {})
  local gui_window = window:gui_window()
  gui_window:perform_action(wezterm.action.ToggleFullScreen, pane)
end)

return config
