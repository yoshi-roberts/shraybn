local function scene_panel()
	Imgui.Begin("Scene", nil)

	if not Editor.current_scene then
		Imgui.End()
		return
	end

	local btn_width = Imgui.GetContentRegionAvail().x
	if Imgui.Button(FONT_ICONS.ICON_PLUS .. " New Layer", Imgui.ImVec2_Float(btn_width, 0)) then
		Imgui.OpenPopup_Str("layer_type_popup")
	end

	if Imgui.BeginPopup("layer_type_popup") then
		if Imgui.MenuItem_Bool(FONT_ICONS.ICON_FILE_IMAGE_O .. " Image Layer") then
			SceneData.new_layer(Editor.current_scene, "image")
		end
		if Imgui.MenuItem_Bool(FONT_ICONS.ICON_MOUSE_POINTER .. " Trigger Layer") then
			SceneData.new_layer(Editor.current_scene, "trigger")
		end

		Imgui.EndPopup()
	end

	for k, layer in pairs(Editor.current_scene.layers) do
		local node_flags = Imgui.love.TreeNodeFlags("OpenOnArrow", "OpenOnDoubleClick")

		if Editor.selected_layer == layer then
			node_flags = Imgui.love.TreeNodeFlags("OpenOnArrow", "OpenOnDoubleClick", "Selected")
		end

		local icon
		if layer.type == "image" then
			icon = FONT_ICONS.ICON_FILE_IMAGE_O
		elseif layer.type == "trigger" then
			icon = FONT_ICONS.ICON_MOUSE_POINTER
		end

		local node_open = Imgui.TreeNodeEx_Str(icon .. " " .. layer.name, node_flags)
		if Imgui.IsItemClicked() then
			Editor.selected_layer = layer
			Inspector:inspect("layer", Editor.selected_layer)
		end

		if Imgui.BeginPopupContextItem() then
			if Imgui.BeginMenu(FONT_ICONS.ICON_PLUS .. "Add") then
				if Imgui.MenuItem_Bool(FONT_ICONS.ICON_PICTURE_O .. " Sprite") then
				end
				if Imgui.MenuItem_Bool(FONT_ICONS.ICON_MOUSE_POINTER .. " Trigger") then
				end
				Imgui.EndMenu()
			end

			if Imgui.MenuItem_Bool(FONT_ICONS.ICON_TRASH .. " Delete") then
				SceneData.remove_layer(Editor.current_scene, k)
			end

			if Imgui.MenuItem_Bool(FONT_ICONS.ICON_I_CURSOR .. "Rename") then
			end
			Imgui.EndPopup()
		end

		if node_open then
			Imgui.TreePop()
		end
	end

	Imgui.End()
end

return scene_panel
