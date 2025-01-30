local mlib = require("libs.mlib")
local input = require("engine.input")
local editor = require("editor")

local AddVertex = require("editor.command.add_vertex")
local RemoveVertex = require("editor.command.remove_vertex")
local ChangeVertex = require("editor.command.change_vertex")

-- TODO: This needs a major rework.

---@alias trigger_edit.vertex {x: integer, y: integer, index: integer}
---@alias trigger_edit.segment {first: trigger_edit.vertex, last: trigger_edit.vertex}

---@class editor.trigger_edit
local trigger_edit = {
	selected = nil, ---@type engine.Trigger
	selected_vert_index = nil, ---@type integer
	new_vertex = nil, ---@type trigger_edit.vertex
	dragging = { active = false, diffx = 0, diffy = 0 },
}

---@param t engine.Trigger
---@param index integer
---@return trigger_edit.vertex
local function get_vertex(t, index)
	local x = t.verticies[index] + t.position.x
	local y = t.verticies[index + 1] + t.position.y
	return { x = x, y = y, index = index }
end

---@param t engine.Trigger
---@param index integer
---@return trigger_edit.segment
local function get_segment(t, index)
	local x, y, x2, y2

	x = t.verticies[index] + t.position.x
	y = t.verticies[index + 1] + t.position.y

	if index ~= #t.verticies - 1 then
		x2 = t.verticies[index + 2] + t.position.x
		y2 = t.verticies[index + 3] + t.position.y
	else
		x2 = t.verticies[1] + t.position.x
		y2 = t.verticies[2] + t.position.y
	end

	local first_vert = { x = x, y = y, index = index }
	local last_vert = { x = x2, y = y2, index = index + 2 }
	return { first = first_vert, last = last_vert }
end

---@param x integer
---@param y integer
---@param segment trigger_edit.segment
---@return trigger_edit.vertex?
-- FIX: This is behaving strangely at the cornsers of two segments.
local function get_segment_intersect(x, y, segment)
	local first = segment.first
	local last = segment.last

	if mlib.circle.getSegmentIntersection(x, y, 8, first.x, first.y, last.x, last.y) then
		local cx, cy = mlib.line.getClosestPoint(x, y, first.x, first.y, last.x, last.y)
		return { x = cx, y = cy, index = first.index + 2 }
	end

	return nil
end

---@param t engine.Trigger
---@param index integer
local function set_vertex_pos(t, index, x, y)
	local nx = x - t.position.x
	local ny = y - t.position.y
	editor.history:add(ChangeVertex:new(t, index, nx, ny, true))
end

---@param t engine.Trigger
local function add_vertex(t, index, x, y)
	local nx = x - t.position.x
	local ny = y - t.position.y
	editor.history:add(AddVertex:new(t, index, nx, ny))
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
		trigger_edit.selected_vert_index = nil
	end
	trigger_edit.new_vertex = nil

	for i = 1, #t.verticies, 2 do
		local vert = get_vertex(t, i)
		local seg = get_segment(t, i)

		if mlib.circle.checkPoint(mouse_pos.x, mouse_pos.y, vert.x, vert.y, 8 / scale) then
			trigger_edit.selected_vert_index = i
		end

		local intersect_vert = get_segment_intersect(mouse_pos.x, mouse_pos.y, seg)
		trigger_edit.new_vertex = intersect_vert and intersect_vert or trigger_edit.new_vertex
	end

	if trigger_edit.selected_vert_index then
		local vert = get_vertex(t, trigger_edit.selected_vert_index)

		if input.button_pressed(input.mouse_button.LEFT) then
			trigger_edit.dragging.acitve = true
			trigger_edit.dragging.diffx = mouse_pos.x - vert.x
			trigger_edit.dragging.diffy = mouse_pos.y - vert.y
		end

		if input.button_released(input.mouse_button.LEFT) then
			trigger_edit.dragging.acitve = false
		end

		if input.button_pressed(input.mouse_button.RIGHT) then
			editor.history:add(RemoveVertex:new(t, vert.index))
		end
	end

	if trigger_edit.dragging.acitve then
		local nx = mouse_pos.x - trigger_edit.dragging.diffx
		local ny = mouse_pos.y - trigger_edit.dragging.diffy
		set_vertex_pos(t, trigger_edit.selected_vert_index, nx, ny)
	end

	if not trigger_edit.selected_vert_index and trigger_edit.new_vertex then
		if input.button_pressed(input.mouse_button.LEFT) then
			local new_vert = trigger_edit.new_vertex
			add_vertex(t, new_vert.index, new_vert.x, new_vert.y)
		end
	end
end

---@param scale number
function trigger_edit.draw(scale)
	local t = trigger_edit.selected
	if not t then
		return
	end

	love.graphics.setLineStyle("smooth")

	for i = 1, #t.verticies, 2 do
		local vert = get_vertex(t, i)
		local seg = get_segment(t, i)

		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.setLineWidth(2)
		love.graphics.line(
			seg.first.x * scale,
			seg.first.y * scale,
			seg.last.x * scale,
			seg.last.y * scale
		)
		love.graphics.setLineWidth(1)

		if trigger_edit.new_vertex and not trigger_edit.selected_vert_index then
			local new_vert = trigger_edit.new_vertex
			local vx = new_vert.x * scale
			local vy = new_vert.y * scale

			love.graphics.setColor(0, 0, 0, 1)
			love.graphics.rectangle("fill", vx - 2, vy - 6, 4, 12)
			love.graphics.rectangle("fill", vx - 6, vy - 2, 12, 4)

			love.graphics.setColor(0, 1, 0, 1)
			love.graphics.rectangle("fill", vx - 1, vy - 5, 2, 10)
			love.graphics.rectangle("fill", vx - 5, vy - 1, 10, 2)
		end

		local vx = seg.first.x * scale
		local vy = seg.first.y * scale

		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.circle("fill", vx, vy, 8, 4)

		love.graphics.setColor(1, 1, 1, 1)
		if i == trigger_edit.selected_vert_index then
			love.graphics.setColor(0, 1, 0, 1)
		end

		love.graphics.circle("fill", vx, vy, 5, 4)
	end
end

return trigger_edit
