local ffi = require("ffi")

Menubar = {
	scene = {
		popup = false,
		name = "New Scene",
	},

	buf = ffi.new("char[?]", 128, "New Scene"),
	display = require("editor.ui.menubar"),
}

function Menubar:new_scene()
	local scene = Scene(self.scene.name)
	local path = "scenes/" .. self.scene.name .. ".scd"

	Nativefs.setWorkingDirectory(Editor.loaded_project.name)
	local exists = Nativefs.getInfo(path)

	if exists ~= nil then
		return false, nil
	end

	scene:save(path)

	-- Set working directory back to projects/
	Nativefs.setWorkingDirectory("..")

	FilePanel:create_tree(Editor.loaded_project.name, FilePanel.tree)
end
