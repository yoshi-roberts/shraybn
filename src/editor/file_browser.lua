local font_icon = require "editor.font_icons"
local nativefs = require("libs.nativefs")
local signal = require("engine.signal")
local imgui = require "engine.imgui"
local ffi = require("ffi")

---@class editor.file_browser
local file_browser = {
	should_open = ffi.new("bool[1]", false),
	selected = nil,

	current_dir = nil,
	previous_dir = nil,
	next_dir = nil,

	win_flags = imgui.love.WindowFlags(
		"NoDocking",
		"NoCollapse",
		"NoResize",
		"NoMove",
		"NoScrollbar",
		"AlwaysAutoResize"
	),
}

function file_browser.open()
	file_browser.should_open[0] = true
	file_browser.current_dir = os.getenv("HOME")
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

		local items = nativefs.getDirectoryItems(file_browser.current_dir)

		if imgui.BeginListBox("##Files", nil) then
			for k, item in pairs(items) do
				if item:sub(1, 1) ~= "." then
					local selected = (k == file_browser.selected)

					local full_path = file_browser.current_dir .. "/" .. item
					local info = nativefs.getInfo(full_path)

					local str = item

					if info.type == "directory" then
						str = font_icon.ICON_FOLDER .. " " .. str
					end

					if imgui.Selectable_Bool(str, selected) then
						file_browser.previous_dir = file_browser.current_dir
						file_browser.current_dir = full_path
						file_browser.selected = k
						break
					end

					if selected then
						imgui.SetItemDefaultFocus()
					end
				end
			end

			imgui.EndListBox()
		end

		if imgui.Button("Cancel") then
			-- file_browser.should_open[0] = false
			imgui.CloseCurrentPopup()
		end

		imgui.EndPopup()
	end
end

return file_browser
