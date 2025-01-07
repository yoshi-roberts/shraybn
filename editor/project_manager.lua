local Project = require("engine.project")
local nativefs = require("libs.nativefs")
local imgui = require("engine.imgui")
local assets = require("engine.assets")
local signal = require("engine.signal")
local editor = require("editor")
local ffi = require("ffi")

-- TODO: Turn this into a seperate project manager/launcher application.

---@class editor.project_manager
local project_manager = {
	projects = nativefs.getDirectoryItems("projects"),
	should_open = ffi.new("bool[1]", false),
	selected = 1,
	warning = "",
	create_new = false,
	name = "New Project",
	buf = ffi.new("char[?]", 128, "New Project"),

	win_flags = imgui.love.WindowFlags(
		"NoDocking",
		"NoCollapse",
		"NoResize",
		"NoMove",
		"NoScrollbar",
		"AlwaysAutoResize"
	),

	display = require("editor.ui.project_manager"),
}

signal.register("menubar_open_project_manager", function()
	project_manager.should_open[0] = true
end)

-- Create a new project.
---@param name string
---@return boolean
function project_manager.create(name)
	local proj_exists = nativefs.getInfo(name)

	if proj_exists then
		print("Exists!")
		project_manager.warning = "Project '" .. name .. "' already exists."
		return false
	end

	print(nativefs.getWorkingDirectory())
	nativefs.createDirectory(name)

	nativefs.createDirectory(name .. "/assets")
	nativefs.createDirectory(name .. "/scenes")

	local proj = Project:new(name) ---@type engine.Project
	proj:save(name)

	-- Update project list.
	project_manager.projects = nativefs.getDirectoryItems("./")

	return true
end

-- Load a project.
---@param name string
function project_manager.load(name)
	local proj = Project.load(name)
	editor.loaded_project = proj

	print(proj.name)
	assets.init(proj.name, true)
	assets.load()

	-- TODO: Almost certainly should not be called here.
	-- viewport.center()
end

return project_manager
