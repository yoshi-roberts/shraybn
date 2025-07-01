local Scene = require("engine.scene")
local Character = require("src.engine.character")
local nativefs = require("libs.nativefs")
local file_panel = require("editor.file_panel")
local editor = require("editor")
local ffi = require("ffi")

---@class editor.menubar
local menubar = {
	popup = {
		open = false,
		name = "New",
		type = "",
	},

	buf = ffi.new("char[?]", 128, "New"),
	display = require("editor.ui.menubar"),
}

-- NOTE: Maybe should not be done like this.
function menubar.new_scene()
	local scene = Scene:new(menubar.popup.name)
	local path = "scenes/" .. menubar.popup.name .. ".scd"

	local exists = nativefs.getInfo(path)

	if exists ~= nil then
		return false, nil
	end

	scene:save(path)

	file_panel.reload_needed = true
end

function menubar.new_character()
	local character = Character:new(menubar.popup.name)
	local path = "characters/" .. menubar.popup.name .. ".chd"

	local exists = nativefs.getInfo(path)

	if exists ~= nil then
		return false, nil
	end

	character:save(path)

	file_panel.reload_needed = true
end

return menubar
