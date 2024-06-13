require("engine")
require("engine.imgui")

require("editor.project")
Binser = require("libs.binser")

SceneData = require("editor.scene_data")
ProjManager = require("editor.project_manager")
require("editor.file_panel")
require("editor.scene_viewer")

Editor = {
	loaded_project = nil,
	open_scenes = {},
	current_scene = nil,
	selected_layer = nil,
}

function Editor:save_scene()
	SceneData.save(self.current_scene)
end

function Editor:save_all_scenes()
	for _, scene in pairs(self.open_scenes) do
		SceneData.save(scene)
	end
end

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
