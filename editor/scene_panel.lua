local function scene_panel()
	Imgui.Begin("Scene", nil)

	if not Editor.current_scene then
		Imgui.End()
		return
	end

	local btn_width = Imgui.GetContentRegionAvail().x
	if Imgui.Button("New Layer", Imgui.ImVec2_Float(btn_width, 0)) then
		SceneData.new_layer(Editor.current_scene)
	end

	for _, layer in pairs(Editor.current_scene.layers) do
		if Imgui.Selectable_Bool(layer.name, Editor.selected_layer == layer) then
			Editor.selected_layer = layer
		end
	end

	Imgui.End()
end

return scene_panel
