local Trigger = require("engine.trigger")
local Canvas = require("engine.canvas")
local Camera = require("engine.camera")
local editor = require("editor")
local window = require("engine.window")
local input = require("engine.input")
local trigger = require("editor.trigger-edit")
local imgui = require "engine.imgui"

---@class editor.viewport
local viewport = {
	canvas = nil, ---@type engine.Canvas
	camera = nil, ---@type engine.Camera
	image = nil,
	scale = 1,
	grid_size = 32,
	is_mouse_over = false,
	dragging = { acitve = false, diffx = 0, diffy = 0 },
	drag_vert = { acitve = false, diffx = 0, diffy = 0, index = 0 },
	bg_color = { 0.15, 0.15, 0.15, 1 },
	dscale = 2 ^ (1 / 6),

	win_flags = imgui.love.WindowFlags("NoScrollbar", "NoScrollWithMouse"),
	display = require("editor.ui.viewport"),
}

function viewport.init()
	viewport.canvas = Canvas:new(window.width, window.height, "none")
	viewport.camera = Camera:new(viewport.canvas)
end

function viewport.center()
	if not editor.loaded_project then
		return
	end

	local width, height = viewport.camera.canvas:get_size()
	local gw = editor.loaded_project.game_width
	local gh = editor.loaded_project.game_height

	local sx = width / gw
	local sy = height / gh
	local scale = math.min(sx, sy)
	viewport.camera.scale = scale

	local x = (width - (gw * scale))
	local y = (height - (gh * scale))
	viewport.camera.position.x = (x / 2)
	viewport.camera.position.y = (y / 2)
end

function viewport.update()
	local cam = viewport.camera
	local cpos = cam:get_position()
	local mpos = input.get_mouse_position()

	if viewport.is_mouse_over then
		if input.button_pressed(input.mouse_button.MIDDLE) then
			viewport.dragging.acitve = true
			viewport.dragging.diffx = mpos.x + cam.position.x
			viewport.dragging.diffy = mpos.y + cam.position.y
		end

		if input:wheel_up() then
			cam:zoom_to(mpos, 0.1)
		end

		if input:wheel_down() then
			cam:zoom_to(mpos, -0.1)
		end
	end

	if input.button_released(input.mouse_button.MIDDLE) then
		viewport.dragging.acitve = false
	end
	--
	if viewport.dragging.acitve then
		cam.position.x = (viewport.dragging.diffx - mpos.x)
		cam.position.y = (viewport.dragging.diffy - mpos.y)
	end

	-- TODO: ??
	-- if editor.selected_entity and editor.selected_entity:is(Trigger) then
	-- trigger:update(editor.selected_entity)
	-- end
end

function viewport.draw_scene()
	for _, entity in pairs(editor.scenes.current.scene.entities) do
		if entity.layer.active then
			entity:draw()

			if entity == trigger.selected then
				trigger:draw()
			end
		end
	end

	for _, layer in pairs(editor.scenes.current.scene.layers) do
		if layer.active and layer.draw ~= nil then
			layer.draw()
		end
	end
end

return viewport
