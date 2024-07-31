require("engine")
require("engine.imgui")

FONT_ICONS = require("editor.font_icons")

require("editor.util")
require("editor.menubar")
require("editor.dockspace")
require("editor.project_manager")
require("editor.file_panel")
require("editor.inspector")
require("editor.viewport")

Editor = {
	---@type Project
	loaded_project = nil,

	scenes = {
		---@type Scene[]
		open = {},
		---@type Scene
		current = nil,
	},

	selected_layer = nil,
	drag_payload = nil,
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
	Window:init(1280, 720)

	Scene("default_scene")
	Engine:set_scene("default_scene")

	-- Make sure projects dir exists and is our working dir.
	local proj_dir_exists = Nativefs.getInfo("projects/")
	if not proj_dir_exists then
		Nativefs.createDirectory("projects")
	end
	Nativefs.setWorkingDirectory("projects")

	require("editor.ui.ui_layer")
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
