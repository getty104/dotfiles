-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- or, changing the font size and color scheme.
config.font_size = 10
config.color_scheme = 'Monokai (base16)'
config.automatically_reload_config = true
config.scrollback_lines = 10000
config.use_ime = true
config.window_background_opacity = 0.8
config.font = wezterm.font("Hack Nerd Font Mono", {weight="Regular", stretch="Normal", style="Normal"})

-- Start in fullscreen mode
local mux = wezterm.mux
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():toggle_fullscreen()
end)

return config
