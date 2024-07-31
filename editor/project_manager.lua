local ffi = require("ffi")

ProjectManager = {
	projects = Nativefs.getDirectoryItems("projects"),
	open = ffi.new("bool[1]", false),
	selected = 1,
	warning = "",
	create_new = false,
	name = "New Project",
	buf = ffi.new("char[?]", 128, "New Project"),

	-- Imgui --
	win_size = Imgui.ImVec2_Float(0.0, 0.0),
	win_flags = Imgui.love.WindowFlags(
		"NoDocking",
		"NoCollapse",
		"NoResize",
		"NoMove",
		-- "NoBringToFrontOnFocus",
		"NoSavedSettings",
		"AlwaysAutoResize"
		-- "NoFocusOnAppearing"
	),

	display = require("editor.ui.project_manager"),
}

function ProjectManager:create(name)
	local proj_exists = Nativefs.getInfo(name)
	if proj_exists then
		print("Exists!")
		self.warning = "Project '" .. name .. "' already exists."
		return false
	end

	Nativefs.createDirectory(name)
	Nativefs.setWorkingDirectory(name)

	Nativefs.createDirectory("assets")
	Nativefs.createDirectory("scenes")

	local proj = Project(name)
	proj:save()

	-- Update project list.
	Nativefs.setWorkingDirectory("..")
	self.projects = Nativefs.getDirectoryItems("./")

	return true
end

function ProjectManager:load(name)
	local proj = Project()
	proj = proj:load(name)

	Editor.loaded_project = proj

	Assets:init(proj.name, true)
	Assets:load()

	Viewport:center()
end
