local Trigger = require("engine.trigger")
local editor = require("editor")
local window = require("engine.window")
local input = require("engine.input")
local trigger = require("editor.trigger-edit")

---@class editor.viewport
local viewport = {
	canvas = nil, ---@type love.Canvas
	image = nil,
	scale = 1,
	grid_size = 32,
	is_mouse_over = false,
	mouse_x = 0,
	mouse_y = 0,
	pos = { x = 0, y = 0 },
	offset = { x = 0, y = 0 },
	dragging = { acitve = false, diffx = 0, diffy = 0 },
	drag_vert = { acitve = false, diffx = 0, diffy = 0, index = 0 },
	bg_color = { 0.15, 0.15, 0.15, 1 },
	dscale = 2 ^ (1 / 6),
	display = require("editor.ui.viewport"),
}

function viewport.init()
	viewport.canvas = love.graphics.newCanvas(window.width, window.height)
end

function viewport.center()
	if not editor.loaded_project then
		return
	end

	local width, height = viewport.canvas:getDimensions()
	local gw = editor.loaded_project.game_width
	local gh = editor.loaded_project.game_height

	local sx = width / gw
	local sy = height / gh
	local scale = math.min(sx, sy)
	viewport.scale = scale

	local x = (width - (gw * scale))
	local y = (height - (gh * scale))
	viewport.offset.x = (x / 2)
	viewport.offset.y = (y / 2)
end

-- TODO: Not working quite right.
-- Kind of need to streamline the whole positioning/scaling process of the viewport.
-- Add a camera system to the engine and utilize that.
function viewport.zoom(y)
	local mpos = input.get_mouse_position()
	local mouse_x = mpos.x - viewport.offset.x
	local mouse_y = mpos.y - viewport.offset.y
	local k = viewport.dscale ^ y
	viewport.scale = viewport.scale * k
	viewport.offset.x = math.floor(viewport.offset.x + mouse_x * (1 - k))
	viewport.offset.y = math.floor(viewport.offset.y + mouse_y * (1 - k))
end

function viewport.update_mouse()
	local mpos = input.get_mouse_position()
	local scaled_x = (viewport.pos.x + viewport.offset.x) / viewport.scale
	local scaled_y = (viewport.pos.y + viewport.offset.y) / viewport.scale

	viewport.mouse_x = mpos.x - scaled_x
	viewport.mouse_y = mpos.y - scaled_y
end

function viewport.update()
	local mpos = input.get_mouse_position()

	if viewport.is_mouse_over then
		if input.button_pressed(input.mouse_button.MIDDLE) then
			viewport.dragging.acitve = true
			viewport.dragging.diffx = mpos.x - viewport.offset.x
			viewport.dragging.diffy = mpos.y - viewport.offset.y
		end

		if input:wheel_up() then
			viewport.zoom(1)
		end

		if input:wheel_down() then
			viewport.zoom(-1)
		end
	end

	if input.button_released(input.mouse_button.MIDDLE) then
		viewport.dragging.acitve = false
	end

	if viewport.dragging.acitve then
		viewport.offset.x = mpos.x - viewport.dragging.diffx
		viewport.offset.y = mpos.y - viewport.dragging.diffy
	end

	-- TODO: ??
	-- if editor.selected_entity and editor.selected_entity:is(Trigger) then
	-- trigger:update(editor.selected_entity)
	-- end

	viewport.update_mouse()
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
