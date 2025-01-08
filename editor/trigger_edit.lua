local mlib = require("libs.mlib")
local input = require("engine.input")

-- TODO: This needs a major rework.

local trigger_edit = {
	selected = nil, ---@type engine.Trigger
	selected_vert = 0,
	selected_segment = nil,
	dragging = { active = false, diffx = 0, diffy = 0 },
}

---@param t engine.Trigger
---@param index integer
---@return integer, integer
local function get_vertex_pos(t, index)
	local x = t.verticies[index]
	local y = t.verticies[index + 1]
	return x, y
end

---@param t engine.Trigger
---@param index integer
local function set_vertex_pos(t, index, x, y)
	t.verticies[index] = x
	t.verticies[index + 1] = y
end

---@param scale number
---@param mouse_pos Vec2
function trigger_edit.update(scale, mouse_pos)
	local t = trigger_edit.selected
	if not t then
		return
	end

	-- We don't want a dragged vertex to get unselected.
	if not trigger_edit.dragging.acitve then
		-- Zero means no vertex is selected.
		trigger_edit.selected_vert = 0
	end

	for i = 1, #t.verticies, 2 do
		local x = t.verticies[i]
		local y = t.verticies[i + 1]

		if mlib.circle.checkPoint(mouse_pos.x, mouse_pos.y, x, y, 8 / scale) then
			trigger_edit.selected_vert = i
		end
	end

	if trigger_edit.selected_vert ~= 0 then
		local vx, vy = get_vertex_pos(t, trigger_edit.selected_vert)

		if input.button_pressed(input.mouse_button.LEFT) then
			trigger_edit.dragging.acitve = true
			trigger_edit.dragging.diffx = mouse_pos.x - vx
			trigger_edit.dragging.diffy = mouse_pos.y - vy
		end
	end

	if input.button_released(input.mouse_button.LEFT) then
		trigger_edit.dragging.acitve = false
	end

	if trigger_edit.dragging.acitve then
		local nx = mouse_pos.x - trigger_edit.dragging.diffx
		local ny = mouse_pos.y - trigger_edit.dragging.diffy
		set_vertex_pos(t, trigger_edit.selected_vert, nx, ny)
	end
end

---@param scale number
function trigger_edit.draw(scale)
	local t = trigger_edit.selected
	if not t then
		return
	end

	for i = 1, #t.verticies, 2 do
		local x = t.verticies[i] * scale
		local y = t.verticies[i + 1] * scale

		love.graphics.setColor(1, 1, 1, 1)

		if i == trigger_edit.selected_vert then
			love.graphics.setColor(0, 1, 0, 1)
		end

		love.graphics.circle("fill", x, y, 8)
	end
end

return trigger_edit
