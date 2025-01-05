local Scene = require("engine.scene")
local nativefs = require("libs.nativefs")
local file_panel = require("editor.file_panel")
local editor = require("editor")
local ffi = require("ffi")

---@class editor.menubar
local menubar = {
	scene = {
		popup = false,
		name = "New Scene",
	},

	buf = ffi.new("char[?]", 128, "New Scene"),
	display = require("editor.ui.menubar"),
}

-- NOTE: Maybe should not be done like this.
function menubar.new_scene()
	local scene = Scene:new(menubar.scene.name)
	local path = "scenes/" .. menubar.scene.name .. ".scd"

	nativefs.setWorkingDirectory(editor.loaded_project.name)
	local exists = nativefs.getInfo(path)

	if exists ~= nil then
		return false, nil
	end

	scene:save(path)

	-- Set working directory back to projects/
	nativefs.setWorkingDirectory("..")
	file_panel.reload_needed = true
end

return menubar
