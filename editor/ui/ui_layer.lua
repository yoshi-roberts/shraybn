local menubar = require("editor.menubar")
local viewport = require("editor.viewport")
local dockspace = require("editor.dockspace")
local scene_panel = require("editor.scene_panel")
local file_panel = require("editor.file_panel")
local inspector = require("editor.inspector")
local project_manager = require("editor.project_manager")

local imgui = require("engine.imgui")
local theme = require("editor.ui.theme")

local function ui_attach()
	imgui.love.Init()

	local io = imgui.GetIO()
	io.ConfigFlags = bit.bor(io.ConfigFlags, imgui.ImGuiConfigFlags_DockingEnable)

	theme.apply()

	viewport.init()
end

local function ui_detach()
	imgui.love.Shutdown()
end

local function ui_update(dt)
	imgui.love.Update(dt)
	imgui.NewFrame()

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

	imgui.Render()
	imgui.love.RenderDrawLists()
end

return {
	attach = ui_attach,
	detach = ui_detach,
	update = ui_update,
	draw = ui_draw,
}
