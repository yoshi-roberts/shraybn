require("engine")
require("engine.imgui")

require("editor.project")
Binser = require("libs.binser")

SceneData = require("editor.scene_data")
ProjManager = require("editor.project_manager")
require("editor.file_panel")

Editor = {
	loaded_project = nil,
	open_scenes = {},
	current_scene = nil,
}

---@diagnostic disable-next-line: duplicate-set-field
function love.load()
	if not Engine.init() then
		Log.fatal("Engine failed to initialize")
	end
	Window:init(1280, 720)

	Scene("default_scene")
	Engine:set_scene("default_scene")

	-- Make sure projects dir exists and is our working dir.
	local proj_dir_exists = Nativefs.getInfo("projects/")
	if not proj_dir_exists then
		Nativefs.createDirectory("projects")
	end
	Nativefs.setWorkingDirectory("projects")

	require("editor.ui_layer")
end

---@diagnostic disable-next-line: duplicate-set-field
function love.update(dt)
	Engine:update(dt)
end

---@diagnostic disable-next-line: duplicate-set-field
function love.draw()
	Engine:draw()
end

function love.quit()
	Engine:shutdown()
end
