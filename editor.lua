require("engine")
require("engine.imgui")

require("editor.project")
Binser = require("libs.binser")

SceneData = require("editor.scene_data")
ProjManager = require("editor.project_manager")
require("editor.file_panel")

Editor = {
	loaded_project = nil,
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
