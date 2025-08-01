local editor = require("editor")
local font_icon = require("editor.font_icons")
local imgui = require("engine.imgui")

local function tab_bar()
	if imgui.BeginTabBar("##scene_tabs", imgui.ImGuiTabBarFlags_AutoSelectNewTabs) then
		if not editor.scenes.current and not editor.characters.current then
			if imgui.BeginTabItem("[empty]") then
				imgui.EndTabItem()
			end
		end

		for name, scene in pairs(editor.scenes.open) do
			local text =
				string.format("%s %s", font_icon.ICON_BOOK, string.match(name, "^.+/(.+)$"))
			if scene.saved == false then
				text = text .. "(*)"
			end

			if imgui.BeginTabItem(text) then
				editor.scenes.current = scene
				imgui.SetWindowFocus_Str("Viewport")
				imgui.EndTabItem()
			end
		end

		for name, character in pairs(editor.characters.open) do
			local text =
				string.format("%s %s", font_icon.ICON_USER, string.match(name, "^.+/(.+)$"))
			if character.saved == false then
				text = text .. "(*)"
			end

			if imgui.BeginTabItem(text) then
				editor.characters.current = character
				imgui.SetWindowFocus_Str("Character")
				imgui.EndTabItem()
			end
		end

		imgui.EndTabBar()
	end
end

return tab_bar
