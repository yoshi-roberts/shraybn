require("engine")
require("engine.imgui")

FONT_ICONS = require("editor.font_icons")

require("editor.command")

require("editor.util")
require("editor.menubar")
require("editor.dockspace")
require("editor.project_manager")
require("editor.scene_data")
require("editor.scene_panel")
require("editor.file_panel")
require("editor.inspector")
require("editor.viewport")

Editor = {
	---@type Project
	loaded_project = nil,

	scenes = {
		---@type SceneData[]
		open = {},
		---@type SceneData
		current = nil,
	},

	history = CommandHistory(),

	selected_layer = nil,
	drag_payload = nil,
}

function Editor:save_scene()
	self.scenes.current.data:save(self.scenes.current.path)
	self.scenes.current.saved = true
end

function Editor:save_all_scenes()
	for _, scene in pairs(self.open_scenes) do
		---@cast scene SceneData

		scene.data:save(scene.path)
		scene.saved = true
	end
end

---@diagnostic disable-next-line: duplicate-set-field
function love.load()
	Window:init(1280, 720)

	local editor_scene = Scene("editor_scene")
	editor_scene:add_layer("ui_layer", require("editor.ui.ui_layer"))

	Engine:set_scene("editor_scene")

	-- Make sure projects dir exists and is our working dir.
	local proj_dir_exists = Nativefs.getInfo("projects/")
	if not proj_dir_exists then
		Nativefs.createDirectory("projects")
	end
	Nativefs.setWorkingDirectory("projects")
end

---@diagnostic disable-next-line: duplicate-set-field
function love.update(dt)
	Engine:update(dt)
	FilePanel:update()
end

---@diagnostic disable-next-line: duplicate-set-field
function love.draw()
	Engine:draw()

	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.circle("fill", Viewport.pos.x, Viewport.pos.y, 4)
	love.graphics.setColor(1, 1, 1, 1)
end

---@diagnostic disable-next-line: duplicate-set-field
function love.quit()
	Engine:shutdown()
end
