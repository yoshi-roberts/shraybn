local mlib = require("libs.mlib")

---@class trigger
local trigger = {
	---@type Trigger
	selected = nil,
	selected_point = nil,
	segment_selected = false,
}

---@return boolean
local function mouse_in_node(x, y)
	local r = 6 / Viewport.scale
	local t = trigger.selected

	local intersects = mlib.circle.checkPoint(
		Viewport.mouse_x,
		Viewport.mouse_y,
		x + t.position.x,
		y + t.position.y,
		r
	)

	return intersects
end

---@return boolean
local function mouse_in_segment(sx, sy, ex, ey)
	local r = 6 / Viewport.scale
	local t = trigger.selected

	local intersects = mlib.circle.getSegmentIntersection(
		Viewport.mouse_x,
		Viewport.mouse_y,
		r,
		sx + t.position.x,
		sy + t.position.y,
		ex + t.position.x,
		ey + t.position.y
	)

	return intersects
end

---@param t Trigger
function trigger:update(t)
	self.selected = t
end

function trigger:draw()
	local r = 6 / Viewport.scale
	local t = self.selected

	love.graphics.push()
	love.graphics.translate(t.position.x, t.position.y)

	self.segment_selected = false

	for i = 1, #t.verticies, 2 do
		local sx = t.verticies[i]
		local sy = t.verticies[i + 1]
		local ex = sx
		local ey = sy

		if i ~= #t.verticies - 1 then
			ex = t.verticies[i + 2]
			ey = t.verticies[i + 3]
		else
			ex = t.verticies[1]
			ey = t.verticies[2]
		end

		local segment_color = { 0.5, 0.5, 0.5, 1 }
		local nx, ny

		if mouse_in_node(sx, sy) then
			nx = sx
			ny = sy
		elseif mouse_in_node(ex, ey) then
			nx = ex
			ny = ey
		end

		if not nx and not ny then
			if not self.segment_selected and mouse_in_segment(sx, sy, ex, ey) then
				self.segment_selected = true
				segment_color = { 0, 1, 0, 1 }
			end
		end

		love.graphics.setColor(segment_color)
		love.graphics.line(sx, sy, ex, ey)

		love.graphics.setColor(0.5, 0.5, 0.5, 1)
		love.graphics.circle("fill", sx, sy, r)

		if nx and ny then
			love.graphics.setColor(0, 1, 0, 1)
			love.graphics.circle("fill", nx, ny, r)
		end
	end

	love.graphics.pop()
end

return trigger
