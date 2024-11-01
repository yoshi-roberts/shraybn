local mlib = require("libs.mlib")

---@class trigger
local trigger = {
	selected_point = nil,
}

---@return boolean
local function mouse_in_segment(sx, sy, ex, ey)
	local r = 6 / Viewport.scale

	local intersects = mlib.circle.getSegmentIntersection(
		Viewport.mouse_x,
		Viewport.mouse_y,
		r,
		sx,
		sy,
		ex,
		ey
	)

	return intersects
end

---@param t Trigger
function trigger:draw(t)
	local r = 6 / Viewport.scale

	self.selected_point = nil

	love.graphics.push()
	love.graphics.translate(t.position.x, t.position.y)

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

		love.graphics.setColor(0.5, 0.5, 0.5, 1)

		if mouse_in_segment(sx, sy, ex, ey) then
			love.graphics.setColor(0, 1, 0, 1)
		end

		love.graphics.line(sx, sy, ex, ey)
		love.graphics.circle("fill", sx, sy, r)
	end

	love.graphics.pop()
end

return trigger
