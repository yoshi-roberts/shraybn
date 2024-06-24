local ffi = require("ffi")

local new_scene_popup = false
local new_scene_name = "New Scene"
local buf = ffi.new("char[?]", 128, "New Scene")

local function menubar()
	if Imgui.BeginMenuBar() then
		local no_proj = (Editor.loaded_project == nil)

		Imgui.BeginDisabled(no_proj)

		if Imgui.BeginMenu("Scene") then
			if Imgui.MenuItem_Bool(string.format("%s New", FONT_ICONS.ICON_PLUS), nil, nil) then
				new_scene_popup = true
			end
			if Imgui.MenuItem_Bool(string.format("%s Save", FONT_ICONS.ICON_FLOPPY_O), nil, nil) then
				Editor:save_scene()
			end
			if Imgui.MenuItem_Bool(string.format("%s Save All", FONT_ICONS.ICON_FLOPPY_O), nil, nil) then
				Editor:save_all_scenes()
			end

			Imgui.EndMenu()
		end

		Imgui.EndDisabled(no_proj)

		if Imgui.BeginMenu("Project") then
			if Imgui.MenuItem_Bool(string.format("%s Open", FONT_ICONS.ICON_FILE), nil, nil) then
				ProjManager.open[0] = true
			end
			Imgui.MenuItem_Bool(FONT_ICONS.ICON_COG .. " Settings", nil, nil)
			Imgui.MenuItem_Bool(FONT_ICONS.ICON_PLAY .. " Run", nil, nil)
			Imgui.MenuItem_Bool(FONT_ICONS.ICON_FLOPPY_O .. " Save", nil, nil)
			Imgui.EndMenu()
		end

		if Imgui.BeginMenu("Editor") then
			if Imgui.BeginMenu(string.format("%s Layout", FONT_ICONS.ICON_ALIGN_JUSTIFY)) then
				if Imgui.MenuItem_Bool("Default", nil, nil) then
					Dockspace:layout("default")
				end
				if Imgui.MenuItem_Bool("Left", nil, nil) then
					Dockspace:layout("left")
				end
				if Imgui.MenuItem_Bool("Right", nil, nil) then
					Dockspace:layout("right")
				end
				if Imgui.MenuItem_Bool("Center", nil, nil) then
					Dockspace:layout("center")
				end
				Imgui.EndMenu()
			end
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
			FilePanel:create_tree(Editor.loaded_project.name, FilePanel.tree)
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
