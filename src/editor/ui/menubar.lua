local dockspace = require("editor.dockspace")
local editor = require("editor")
local signal = require("engine.signal")
local ffi = require("ffi")

local font_icon = require("editor.font_icons")
local imgui = require("engine.imgui")

---@param menubar editor.menubar
local function scene_menu(menubar)
	local new_str = string.format("%s New", font_icon.ICON_PLUS)
	if imgui.MenuItem_Bool(new_str, nil, nil) then
		menubar.popup.open = true
		menubar.popup.type = "scene"
	end

	local save_str = string.format("%s Save", font_icon.ICON_FLOPPY_O)
	if imgui.MenuItem_Bool(save_str, nil, nil) then
		editor:save_scene()
	end

	local save_all_str = string.format("%s Save All", font_icon.ICON_FLOPPY_O)
	if imgui.MenuItem_Bool(save_all_str, nil, nil) then
		editor:save_all_scenes()
	end

	imgui.Separator()

	local undo_str = string.format("%s Undo", font_icon.ICON_UNDO)
	if imgui.MenuItem_Bool(undo_str, nil, nil) then
		editor.history:undo()
	end

	local redo_str = string.format("%s Redo", font_icon.ICON_REPEAT)
	if imgui.MenuItem_Bool(redo_str, nil, nil) then
		editor.history:redo()
	end
end

local function character_menu(menubar)
	local new_str = string.format("%s New", font_icon.ICON_PLUS)
	if imgui.MenuItem_Bool(new_str, nil, nil) then
		menubar.popup.open = true
		menubar.popup.type = "character"
	end
end

local function project_menu()
	if imgui.MenuItem_Bool(string.format("%s Open", font_icon.ICON_FILE), nil, nil) then
		-- signal.emit("menubar_open_project_manager")
		signal.emit("file_browser_open", "open")
	end

	if imgui.MenuItem_Bool(font_icon.ICON_PLUS .. " New", nil, nil) then
		signal.emit("file_browser_open", "create")
	end

	imgui.MenuItem_Bool(font_icon.ICON_COG .. " Settings", nil, nil)
	if imgui.MenuItem_Bool(font_icon.ICON_PLAY .. " Run", nil, nil) then
		if editor.loaded_project then
			local cmd = "cd .. && ./love runtime.lua projects/"
			cmd = cmd .. editor.loaded_project.name .. " &"
			local p = assert(io.popen(cmd))
			p:close()
		end
	end
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

		if imgui.BeginMenu("Character") then
			character_menu(menubar)
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

	if menubar.popup.open then
		imgui.OpenPopup_Str("new_popup")
		menubar.popup.open = false
	end

	if imgui.BeginPopup("new_popup") then
		imgui.Text("Name")
		if imgui.InputText("##popup_name_field", menubar.buf, 128) then
			menubar.popup.name = ffi.string(menubar.buf)
		end

		if imgui.Button("Create") then
			if menubar.popup.type == "scene" then
				menubar.new_scene()
			else
				menubar.new_character()
			end
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
