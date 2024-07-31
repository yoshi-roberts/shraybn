local function scene_tabs()
	if Imgui.BeginTabBar("##scene_tabs", Imgui.ImGuiTabBarFlags_AutoSelectNewTabs) then
		if not Editor.scenes.current then
			if Imgui.BeginTabItem("[empty]") then
				Imgui.EndTabItem()
			end
		end

		for name, scene in pairs(Editor.scenes.open) do
			---@cast scene SceneData

			local text = string.format("%s %s", FONT_ICONS.ICON_BOOK, string.match(name, "^.+/(.+)$"))
			if scene.saved == false then
				text = text .. "(*)"
			end

			if Imgui.BeginTabItem(text) then
				Editor.scenes.current = scene
				Imgui.EndTabItem()
			end
		end

		Imgui.EndTabBar()
	end
end

return scene_tabs
