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
		Editor.history:add(AddLayer(scene, Layer({})))
	end

	for k, layer in pairs(scene.data.layers) do
		local node_flags = Imgui.love.TreeNodeFlags("OpenOnArrow", "OpenOnDoubleClick")

		if Editor.selected_layer == layer then
			node_flags = Imgui.love.TreeNodeFlags("OpenOnArrow", "OpenOnDoubleClick", "Selected")
		end

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
		local node_open = Imgui.TreeNodeEx_Str(layer.name, node_flags)

		if Imgui.BeginPopupContextItem() then
			if Imgui.BeginMenu(FONT_ICONS.ICON_PLUS .. "Add") then
				if Imgui.MenuItem_Bool(FONT_ICONS.ICON_PICTURE_O .. " Sprite") then
					Editor.history:add(AddEntity(scene, layer, Sprite()))
				end
				if Imgui.MenuItem_Bool(FONT_ICONS.ICON_MOUSE_POINTER .. " Trigger") then
					Editor.history:add(AddEntity(scene, layer, Trigger({ 0, 0, 64, 0, 64, 64, 0, 64 })))
				end
				Imgui.EndMenu()
			end

			if Imgui.MenuItem_Bool(FONT_ICONS.ICON_TRASH .. " Delete") then
				ScenePanel.remove_layer(scene, k)
			end

			Imgui.EndPopup()
		end

		if node_open then
			for j, entity in pairs(scene.data.entities) do
				if entity.layer == layer then
					if Imgui.Selectable_Bool(entity.name) then
						Inspector:inspect("entity", entity)
					end

					if Imgui.BeginPopupContextItem() then
						if Imgui.MenuItem_Bool(FONT_ICONS.ICON_TRASH .. " Delete") then
							Editor.history:add(RemoveEntity(scene, j))
						end

						Imgui.EndPopup()
					end
				end
			end

			Imgui.TreePop()
		end

		if Imgui.IsItemClicked() then
			Editor.selected_layer = layer
			Inspector:inspect("layer", Editor.selected_layer)
		end
	end

	Imgui.End()
end

return display
