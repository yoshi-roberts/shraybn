local function display()
	Imgui.Begin("Scene", nil)

	if not Editor.scenes.current then
		Imgui.End()
		return
	end

	---@type SceneData
	local scene = Editor.scenes.current

	local btn_width = Imgui.GetContentRegionAvail().x
	if Imgui.Button(FONT_ICONS.ICON_PLUS .. " New Layer", Imgui.ImVec2_Float(btn_width, 0)) then
		Imgui.OpenPopup_Str("layer_type_popup")
	end

	if Imgui.BeginPopup("layer_type_popup") then
		if Imgui.MenuItem_Bool(FONT_ICONS.ICON_FILE_IMAGE_O .. " Sprite Layer") then
			ScenePanel.add_layer(scene, "sprite")
		end
		if Imgui.MenuItem_Bool(FONT_ICONS.ICON_MOUSE_POINTER .. " Trigger Layer") then
			ScenePanel.add_layer(scene, "trigger")
		end

		Imgui.EndPopup()
	end

	for k, layer in pairs(scene.data.layers) do
		local node_flags = Imgui.love.TreeNodeFlags("OpenOnArrow", "OpenOnDoubleClick")

		if Editor.selected_layer == layer then
			node_flags = Imgui.love.TreeNodeFlags("OpenOnArrow", "OpenOnDoubleClick", "Selected")
		end

		local icon
		-- if layer.type == "image" then
		-- 	icon = FONT_ICONS.ICON_FILE_IMAGE_O
		-- elseif layer.type == "trigger" then
		-- 	icon = FONT_ICONS.ICON_MOUSE_POINTER
		-- end

		local eye
		if layer.active then
			eye = FONT_ICONS.ICON_EYE
		else
			eye = FONT_ICONS.ICON_EYE_SLASH
		end

		if Imgui.Button(eye .. "##" .. layer.name) then
			layer.active = not layer.active
			scene.saved = false
		end

		Imgui.SameLine()
		-- local node_open = Imgui.TreeNodeEx_Str(icon .. " " .. layer.name, node_flags)
		-- local node_open = Imgui.TreeNodeEx_Str(layer.name, node_flags)
		if Imgui.TreeNodeEx_Str(layer.name, node_flags) then
			for _, entity in pairs(scene.data.entities) do
				if entity.layer == layer then
					Imgui.Selectable_Bool(entity.name)
				end
			end

			Imgui.TreePop()
		end

		if Imgui.IsItemClicked() then
			Editor.selected_layer = layer
			-- Inspector:inspect("layer", Editor.selected_layer)
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
			end

			if Imgui.MenuItem_Bool(FONT_ICONS.ICON_I_CURSOR .. "Rename") then
			end
			Imgui.EndPopup()
		end
	end

	Imgui.End()
end

return display
