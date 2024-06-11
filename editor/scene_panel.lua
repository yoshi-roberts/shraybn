local function scene_panel()
	Imgui.Begin("Scene", nil)

	if not Editor.current_scene then
		Imgui.End()
		return
	end

	if Imgui.BeginListBox("##layers", nil) then
		for k, v in pairs(Editor.current_scene.layers) do
			local selected = (k == proj_manager.selected)

			if Imgui.Selectable_Bool(v, selected) then
				proj_manager.selected = k
			end

			if selected then
				Imgui.SetItemDefaultFocus()
			end
		end

		Imgui.EndListBox()
	end

	Imgui.End()
end

return scene_panel
