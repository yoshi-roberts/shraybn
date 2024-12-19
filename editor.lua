local CommandHistory = require("editor.command.command_history")
local Scene = require("engine.scene")
local Layer = require("engine.layer")
local nativefs = require("libs.nativefs")
local window = require("engine.window")
local engine = require("engine")

-- require("editor.menubar")
-- require("editor.dockspace")
-- require("editor.project_manager")
-- require("editor.scene_data")
-- require("editor.scene_panel")
-- require("editor.file_panel")
-- require("editor.inspector")
-- require("editor.viewport")

---@class editor
local editor = {
	loaded_project = nil, ---@type engine.Project

	scenes = {
		open = {}, ---@type editor.SceneData[]
		current = nil, ---@type editor.SceneData
	},

	history = CommandHistory:new(),

	selected_layer = nil, ---@type engine.Layer
	selected_entity = nil, ---@type engine.Entity
	drag_payload = nil,
}

function editor.save_scene()
	editor.scenes.current.data:save(editor.scenes.current.path)
	editor.scenes.current.saved = true
end

function editor.save_all_scenes()
	for _, scene in pairs(editor.scenes.open) do
		---@cast scene editor.SceneData

		scene.data:save(scene.path)
		scene.saved = true
	end
end

---@diagnostic disable-next-line: duplicate-set-field
function love.load()
	window.init()

	local editor_scene = engine.add_scene(Scene:new("editor_scene"))
	editor_scene:add_layer(Layer:new(require("editor.ui.ui_layer")))

	engine.set_scene("editor_scene")

	-- Make sure projects dir exists and is our working dir.
	local proj_dir_exists = nativefs.getInfo("projects/")
	if not proj_dir_exists then
		nativefs.createDirectory("projects")
	end
	nativefs.setWorkingDirectory("projects")
end

---@diagnostic disable-next-line: duplicate-set-field
function love.update(dt)
	engine.update(dt)
	-- file_panel.update() -- FIX: Should not be here.
end

---@diagnostic disable-next-line: duplicate-set-field
function love.draw()
	engine.draw()

	-- FIX: No no.
	-- love.graphics.setColor(1, 0, 0, 1)
	-- love.graphics.circle("fill", viewport.pos.x, viewport.pos.y, 4)
	-- love.graphics.setColor(1, 1, 1, 1)
end

---@diagnostic disable-next-line: duplicate-set-field
function love.quit()
	engine.shutdown()
end

return editor
