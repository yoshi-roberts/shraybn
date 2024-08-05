local ffi = require("ffi")

local function scene_menu(self)
	if Imgui.MenuItem_Bool(string.format("%s New", FONT_ICONS.ICON_PLUS), nil, nil) then
		self.scene.popup = true
	end
	if Imgui.MenuItem_Bool(string.format("%s Save", FONT_ICONS.ICON_FLOPPY_O), nil, nil) then
		Editor:save_scene()
	end
	if Imgui.MenuItem_Bool(string.format("%s Save All", FONT_ICONS.ICON_FLOPPY_O), nil, nil) then
		Editor:save_all_scenes()
	end

	Imgui.Separator()

	if Imgui.MenuItem_Bool(string.format("%s Undo", FONT_ICONS.ICON_UNDO), nil, nil) then
		Editor.history:undo()
	end

	if Imgui.MenuItem_Bool(string.format("%s Redo", FONT_ICONS.ICON_REPEAT), nil, nil) then
		Editor.history:redo()
	end
end

local function project_menu()
	if Imgui.MenuItem_Bool(string.format("%s Open", FONT_ICONS.ICON_FILE), nil, nil) then
		ProjectManager.open[0] = true
	end

	Imgui.MenuItem_Bool(FONT_ICONS.ICON_COG .. " Settings", nil, nil)
	Imgui.MenuItem_Bool(FONT_ICONS.ICON_PLAY .. " Run", nil, nil)
	Imgui.MenuItem_Bool(FONT_ICONS.ICON_FLOPPY_O .. " Save", nil, nil)
end

local function editor_menu()
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
end

local function display(self)
	if Imgui.BeginMenuBar() then
		local no_proj = (Editor.loaded_project == nil)

		Imgui.BeginDisabled(no_proj)

		if Imgui.BeginMenu("Scene") then
			scene_menu(self)
			Imgui.EndMenu()
		end

		Imgui.EndDisabled(no_proj)

		if Imgui.BeginMenu("Project") then
			project_menu()
			Imgui.EndMenu()
		end

		if Imgui.BeginMenu("Editor") then
			editor_menu()
			Imgui.EndMenu()
		end

		Imgui.EndMenuBar()
	end

	if self.scene.popup then
		Imgui.OpenPopup_Str("new_scene")
		self.scene.popup = false
	end

	if Imgui.BeginPopup("new_scene") then
		Imgui.Text("Scene Name")
		if Imgui.InputText("##scene_field", self.buf, 128) then
			self.scene.name = ffi.string(self.buf)
		end

		if Imgui.Button("Create") then
			self:new_scene()
			Imgui.CloseCurrentPopup()
		end

		Imgui.SameLine()
		if Imgui.Button("Cancel") then
			Imgui.CloseCurrentPopup()
		end
		Imgui.EndPopup()
	end
end

return display
