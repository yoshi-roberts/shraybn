local Project = require("engine.project")
local nativefs = require("libs.nativefs")
local imgui = require("engine.imgui")
local assets = require("engine.assets")
local viewport = require("editor.viewport")
local signal = require("engine.signal")
local editor = require("editor")
local ffi = require("ffi")

---@class editor.project_manager
local project_manager = {
	projects = nativefs.getDirectoryItems("projects"),
	open = ffi.new("bool[1]", false),
	selected = 1,
	warning = "",
	create_new = false,
	name = "New Project",
	buf = ffi.new("char[?]", 128, "New Project"),

	-- Imgui --
	win_size = imgui.ImVec2_Float(0.0, 0.0),
	win_flags = imgui.love.WindowFlags(
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

local function project_manager_open()
	project_manager.open[0] = true
end

signal.register("menubar_open_project_manager", project_manager_open)

---@param name string
---@return boolean
function project_manager.create(name)
	local proj_exists = nativefs.getInfo(name)
	if proj_exists then
		print("Exists!")
		project_manager.warning = "Project '" .. name .. "' already exists."
		return false
	end

	nativefs.createDirectory(name)
	nativefs.setWorkingDirectory(name)

	nativefs.createDirectory("assets")
	nativefs.createDirectory("scenes")

	local proj = Project:new(name)
	proj:save()

	-- Update project list.
	nativefs.setWorkingDirectory("..")
	project_manager.projects = nativefs.getDirectoryItems("./")

	return true
end

---@param name string
function project_manager.load(name)
	local proj = Project.load(name)
	editor.loaded_project = proj

	assets.init(proj.name, true)
	assets.load()

	viewport.center()
end

return project_manager
