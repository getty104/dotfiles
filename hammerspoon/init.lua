local open_wezterm = function()
	local appName = "WezTerm"
	local app = hs.application.get(appName)

	if app == nil or app:isHidden() or not (app:isFrontmost()) then
		hs.application.launchOrFocus(appName)
	else
		app:hide()
	end
end
-- 「Ctrl+t」のショートカットで表示／非表示を切り替える場合の設定
hs.hotkey.bind({ "ctrl" }, "j", open_wezterm)
