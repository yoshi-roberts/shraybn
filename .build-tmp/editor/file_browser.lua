local font_icon = require "editor.font_icons"
local nativefs = require("libs.nativefs")
local project_manager = require("editor.project_manager")
local signal = require("engine.signal")
local imgui = require "engine.imgui"
local ffi = require("ffi")

---@class editor.file_browser
local file_browser = {
	should_open = ffi.new("bool[1]", false),
	selected_index = nil,
	selected_path = "",

	mode = nil,
	home_dir = nil,
	current_dir = nil,
	previous_dir = nil,
	next_dir = nil,

	buf = ffi.new("char[?]", 128, "New Project"),
	create_name = "",

	win_flags = imgui.love.WindowFlags(
		"NoDocking",
		"NoCollapse",
		"NoResize",
		"NoMove",
		"NoScrollbar",
		"AlwaysAutoResize"
	),
}

function file_browser.open(mode)
	file_browser.mode = mode
	file_browser.should_open[0] = true
	file_browser.home_dir = os.getenv("HOME")
	file_browser.current_dir = file_browser.home_dir
end

function file_browser.close()
	file_browser.should_open[0] = false
end

signal.register("file_browser_open", file_browser.open)

function file_browser.display()
	if file_browser.should_open[0] then
		imgui.OpenPopup_Str("File Browser")
		-- file_browser.should_open[0] = false
	end

	local screen_w, screen_h = love.graphics.getDimensions()

	local pos_x = screen_w * 0.5
	local pos_y = screen_h * 0.5

	imgui.SetNextWindowPos(
		imgui.ImVec2_Float(pos_x, pos_y),
		imgui.ImGuiCond_Always,
		imgui.ImVec2_Float(0.5, 0.5)
	)

	if imgui.BeginPopupModal("File Browser", nil, file_browser.win_flags) then
		if imgui.Button(font_icon.ICON_ARROW_LEFT) then
			if file_browser.previous_dir then
				file_browser.current_dir = file_browser.previous_dir
			end
		end

		imgui.SameLine()

		if imgui.Button(font_icon.ICON_ARROW_RIGHT) then
		end

		imgui.SameLine()

		if imgui.Button(font_icon.ICON_ARROW_UP) then
			local trimmed_path = file_browser.current_dir:match("(.+)/[^/]+$")
				or file_browser.current_dir

			if #trimmed_path >= #file_browser.home_dir then
				local exists = nativefs.getInfo(trimmed_path)
				if exists then
					file_browser.current_dir = trimmed_path
				end
			end
		end

		local items = nativefs.getDirectoryItems(file_browser.current_dir)

		if imgui.BeginListBox("##Files", nil) then
			for k, item in pairs(items) do
				if item:sub(1, 1) ~= "." then
					local selected = (k == file_browser.selected_index)

					local full_path = file_browser.current_dir .. "/" .. item
					local info = nativefs.getInfo(full_path)

					local str = item

					if info.type == "directory" then
						str = font_icon.ICON_FOLDER .. " " .. str
					end

					if imgui.Selectable_Bool(str, selected) then
						file_browser.selected_index = k
						file_browser.selected_path = full_path
					end

					if imgui.IsItemHovered() and imgui.IsMouseDoubleClicked_Nil(0) then
						file_browser.previous_dir = file_browser.current_dir
						file_browser.current_dir = full_path
						break
					end

					if selected then
						imgui.SetItemDefaultFocus()
					end
				end
			end

			imgui.EndListBox()
		end

		if file_browser.mode == "create" then
			if imgui.InputText("##file_name", file_browser.buf, 128) then
				file_browser.create_name = ffi.string(file_browser.buf)
			end
		end

		if imgui.Button("Cancel") then
			file_browser.should_open[0] = false
			imgui.CloseCurrentPopup()
		end

		imgui.SameLine()

		if imgui.Button("Confirm") then
			if file_browser.mode == "open" then
				project_manager.load(file_browser.selected_path)
			elseif file_browser.mode == "create" then
				local new_path = file_browser.current_dir .. "/" .. file_browser.create_name
				print(new_path)
				project_manager.create(file_browser.create_name, new_path)
			end

			file_browser.should_open[0] = false
			imgui.CloseCurrentPopup()
			-- signal.emit("file_browser_select", file_browser.selected_path)
		end

		imgui.EndPopup()
	end
end

return file_browser
