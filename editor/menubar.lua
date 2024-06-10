local function menubar()
	if Imgui.BeginMenuBar() then
		if Imgui.BeginMenu("Scene") then
			Imgui.MenuItem_Bool("New", nil, nil)
			Imgui.EndMenu()
		end

		if Imgui.BeginMenu("Project") then
			if Imgui.MenuItem_Bool("Manager", nil, nil) then
				ProjManager.open[0] = true
			end
			Imgui.MenuItem_Bool("Settings", nil, nil)
			Imgui.MenuItem_Bool("Save", nil, nil)
			Imgui.EndMenu()
		end
		Imgui.EndMenuBar()
	end
end

return menubar
