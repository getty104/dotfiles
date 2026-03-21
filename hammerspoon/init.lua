local open_wezterm = function()
  local appName = "WezTerm"
  local app = hs.application.get(appName)

  if app == nil then
    hs.application.launchOrFocus(appName)
  elseif hs.application.frontmostApplication():name() == appName then
    hs.osascript.applescript('tell application "System Events" to set visible of process "WezTerm" to false')
  else
    app:activate()
  end
end
-- 「Ctrl+t」のショートカットで表示／非表示を切り替える場合の設定
hs.hotkey.bind({ "ctrl" }, "j", open_wezterm)
