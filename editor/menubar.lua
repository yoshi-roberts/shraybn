local ffi = require("ffi")

local new_scene_popup = false
local new_scene_name = "New Scene"
local buf = ffi.new("char[?]", 128, "New Scene")

local function menubar()
	if Imgui.BeginMenuBar() then
		local no_proj = (Editor.loaded_project == nil)

		Imgui.BeginDisabled(no_proj)

		if Imgui.BeginMenu("Scene") then
			if Imgui.MenuItem_Bool("New", nil, nil) then
				new_scene_popup = true
			end

			Imgui.EndMenu()
		end

		Imgui.EndDisabled(no_proj)

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

	if new_scene_popup then
		Imgui.OpenPopup_Str("new_scene")
		new_scene_popup = false
	end

	if Imgui.BeginPopup("new_scene") then
		Imgui.Text("Scene Name")
		if Imgui.InputText("##scene_field", buf, 128) then
			new_scene_name = ffi.string(buf)
		end

		if Imgui.Button("Create") then
			local scene = SceneData.new(new_scene_name)
			Imgui.CloseCurrentPopup()
		end

		Imgui.SameLine()
		if Imgui.Button("Cancel") then
			Imgui.CloseCurrentPopup()
		end
		Imgui.EndPopup()
	end
end

return menubar
