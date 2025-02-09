local mlib = require("libs.mlib")

---@class trigger
local trigger = {
	---@type Trigger
	selected = nil,
	selected_point = nil,
	selected_segment = nil,
	dragging = { active = false, diffx = 0, diffy = 0 },
}

---@param t Trigger
---@param i integer
local function get_verts(t, i)
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

	return sx, sy, ex, ey
end

---@param t Trigger
---@param i integer
---@param x integer
---@param y integer
local function set_vert(t, i, x, y)
	t.verticies[i] = x
	t.verticies[i + 1] = y
end

local function same_node(a, b)
	return a[1] == b[1] and a[2] == b[2]
end

local function same_segment(a, b)
	return same_node({ a[1], a[2] }, { b[1], b[2] })
		and same_node({ a[3], a[4] }, { b[3], b[4] })
end

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

	local r = 6 / Viewport.scale

	if not self.dragging.acitve then
		self.selected_point = nil
	end
	self.selected_segment = nil

	for i = 1, #t.verticies, 2 do
		local sx, sy, ex, ey = get_verts(t, i)

		local nx, ny

		if mouse_in_node(sx, sy) then
			nx = sx
			ny = sy
		elseif mouse_in_node(ex, ey) then
			nx = ex
			ny = ey
		end

		-- Node is selected.
		if nx and ny then
			self.selected_point = { nx, ny, i }
		else
			-- Segment is selected.
			if not self.selected_segment and mouse_in_segment(sx, sy, ex, ey) then
				self.selected_segment = { sx, sy, ex, ey, i }
			end
		end
	end

	if Input:button_pressed(MOUSE_BUTTON.LEFT) then
		if self.selected_segment then
			local i = self.selected_segment[5]
			table.insert(t.verticies, i + 2, Viewport.mouse_x - self.selected.position.x)
			table.insert(t.verticies, i + 3, Viewport.mouse_y - self.selected.position.y)
		end

		if self.selected_point then
			self.dragging.acitve = true
			self.dragging.diffx = Viewport.mouse_x - self.selected_point[1]
			self.dragging.diffy = Viewport.mouse_y - self.selected_point[2]
			t.tris = love.math.triangulate(t.verticies)
		end
	end

	if Input:button_released(MOUSE_BUTTON.LEFT) and self.dragging.acitve then
		self.dragging.acitve = false
		t.tris = love.math.triangulate(t.verticies)
	end

	if self.dragging.acitve then
		set_vert(
			t,
			self.selected_point[3],
			Viewport.mouse_x - self.dragging.diffx,
			Viewport.mouse_y - self.dragging.diffy
		)
	end
end

function trigger:draw()
	local r = 6 / Viewport.scale
	local t = self.selected

	love.graphics.push()
	love.graphics.translate(t.position.x, t.position.y)

	for i = 1, #t.verticies, 2 do
		local sx, sy, ex, ey = get_verts(t, i)

		local segment_color = { 0.5, 0.5, 0.5, 1 }

		if self.selected_segment then
			if same_segment(self.selected_segment, { sx, sy, ex, ey }) then
				segment_color = { 0, 1, 0, 1 }
			end
		end

		love.graphics.setColor(segment_color)
		love.graphics.line(sx, sy, ex, ey)

		local point_color = { 0.5, 0.5, 0.5, 1 }

		if self.selected_point then
			if same_node(self.selected_point, { sx, sy }) then
				point_color = { 0, 1, 0, 1 }
			end
		end

		love.graphics.setColor(point_color)
		love.graphics.circle("fill", sx, sy, r)
	end

	love.graphics.pop()
end

return trigger
