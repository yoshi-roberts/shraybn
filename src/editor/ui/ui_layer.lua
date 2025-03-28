local menubar = require("editor.menubar")
local viewport = require("editor.viewport")
local dockspace = require("editor.dockspace")
local scene_panel = require("editor.scene_panel")
local file_panel = require("editor.file_panel")
local file_browser = require("editor.file_browser")
local inspector = require("editor.inspector")
local project_manager = require("editor.project_manager")

local imgui = require("engine.imgui")

local function ui_attach()
	imgui.engine.init(true, true)
	viewport.init()
end

local function ui_detach()
	imgui.engine.shutdown()
end

local function ui_update(dt)
	imgui.engine.update(dt)

	file_panel.update()
	viewport.update()
end

local function ui_draw()
	dockspace.display()
	menubar.display(menubar)
	dockspace.finish()

	scene_panel.display()
	file_panel.display(file_panel)
	viewport.display(viewport)
	inspector.display(inspector)
	project_manager.display(project_manager)
	file_browser.display()

	imgui.engine.draw()
end

return {
	attach = ui_attach,
	detach = ui_detach,
	update = ui_update,
	draw = ui_draw,
}
