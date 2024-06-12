local function scene_panel()
	Imgui.Begin("Scene", nil)

	if not Editor.current_scene then
		Imgui.End()
		return
	end

	local btn_width = Imgui.GetContentRegionAvail().x
	Imgui.Button("New Layer", Imgui.ImVec2_Float(btn_width, 0))

	Imgui.End()
end

return scene_panel
