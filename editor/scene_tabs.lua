local editor = require("editor")
local font_icon = require("editor.font_icons")
local imgui = require("engine.imgui")

local function scene_tabs()
	if imgui.BeginTabBar("##scene_tabs", imgui.ImGuiTabBarFlags_AutoSelectNewTabs) then
		if not editor.scenes.current then
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
				imgui.EndTabItem()
			end
		end

		imgui.EndTabBar()
	end
end

return scene_tabs
