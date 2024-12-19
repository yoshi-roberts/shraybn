local dockspace = require("editor.dockspace")
local editor = require("editor")
local ffi = require("ffi")

local font_icon = require("editor.font_icons")
local imgui = require("engine.imgui")

---@param menubar editor.menubar
local function scene_menu(menubar)
	if imgui.MenuItem_Bool(string.format("%s New", font_icon.ICON_PLUS), nil, nil) then
		menubar.scene.popup = true
	end
	if imgui.MenuItem_Bool(string.format("%s Save", font_icon.ICON_FLOPPY_O), nil, nil) then
		editor:save_scene()
	end
	if imgui.MenuItem_Bool(string.format("%s Save All", font_icon.ICON_FLOPPY_O), nil, nil) then
		editor:save_all_scenes()
	end

	imgui.Separator()

	if imgui.MenuItem_Bool(string.format("%s Undo", font_icon.ICON_UNDO), nil, nil) then
		editor.history:undo()
	end

	if imgui.MenuItem_Bool(string.format("%s Redo", font_icon.ICON_REPEAT), nil, nil) then
		editor.history:redo()
	end
end

local function project_menu()
	if imgui.MenuItem_Bool(string.format("%s Open", font_icon.ICON_FILE), nil, nil) then
		-- FIX: Probably bad
		-- ProjectManager.open[0] = true
	end

	imgui.MenuItem_Bool(font_icon.ICON_COG .. " Settings", nil, nil)
	imgui.MenuItem_Bool(font_icon.ICON_PLAY .. " Run", nil, nil)
	imgui.MenuItem_Bool(font_icon.ICON_FLOPPY_O .. " Save", nil, nil)
end

local function editor_menu()
	if imgui.BeginMenu(string.format("%s Layout", font_icon.ICON_ALIGN_JUSTIFY)) then
		if imgui.MenuItem_Bool("Default", nil, nil) then
			dockspace.layout("default")
		end
		if imgui.MenuItem_Bool("Left", nil, nil) then
			dockspace.layout("left")
		end
		if imgui.MenuItem_Bool("Right", nil, nil) then
			dockspace.layout("right")
		end
		if imgui.MenuItem_Bool("Center", nil, nil) then
			dockspace.layout("center")
		end
		imgui.EndMenu()
	end
end

---@param menubar editor.menubar
local function display(menubar)
	if imgui.BeginMenuBar() then
		local no_proj = (editor.loaded_project == nil)

		imgui.BeginDisabled(no_proj)

		if imgui.BeginMenu("Scene") then
			scene_menu(menubar)
			imgui.EndMenu()
		end

		imgui.EndDisabled(no_proj)

		if imgui.BeginMenu("Project") then
			project_menu()
			imgui.EndMenu()
		end

		if imgui.BeginMenu("Editor") then
			editor_menu()
			imgui.EndMenu()
		end

		imgui.EndMenuBar()
	end

	if menubar.scene.popup then
		imgui.OpenPopup_Str("new_scene")
		menubar.scene.popup = false
	end

	if imgui.BeginPopup("new_scene") then
		imgui.Text("Scene Name")
		if imgui.InputText("##scene_field", menubar.buf, 128) then
			menubar.scene.name = ffi.string(menubar.buf)
		end

		if imgui.Button("Create") then
			menubar.new_scene()
			imgui.CloseCurrentPopup()
		end

		imgui.SameLine()
		if imgui.Button("Cancel") then
			imgui.CloseCurrentPopup()
		end
		imgui.EndPopup()
	end
end

return display
