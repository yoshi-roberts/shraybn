-- require("editor")
local CommandHistory = require("editor.command.command_history")
local Scene = require("engine.scene")
local Layer = require("engine.layer")
local nativefs = require("libs.nativefs")
local window = require("engine.window")
local engine = require("engine")

---@class editor
local editor = {}

editor.loaded_project = nil ---@type engine.Project
editor.selected_layer = nil ---@type engine.Layer
editor.selected_entity = nil ---@type engine.Entity

editor.history = CommandHistory:new()

-- NOTE: Maybe SceneData should be stored in the project.
-- That could be cleaner.
-- We can also save the sate of opened scenes as part of the proj file.
editor.scenes = {
	open = {}, ---@type editor.SceneData[]
	current = nil, ---@type editor.SceneData
}

function editor.save_scene()
	local proj_path = nativefs.getWorkingDirectory() .. "/" .. editor.loaded_project.name
	editor.loaded_project:save(proj_path)
	if not editor.scenes.current then
		return
	end

	editor.scenes.current.scene:save(editor.scenes.current.path)
	editor.scenes.current.saved = true
end

function editor.save_all_scenes()
	for _, scene in pairs(editor.scenes.open) do
		scene.scene:save(scene.path)
		scene.saved = true
	end
end

function engine.init()
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

return editor
