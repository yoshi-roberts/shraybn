local trigger = require("editor.trigger-edit") --[[@as trigger]]

Viewport = {
	canvas = nil,
	image = nil,
	scale = 1,
	grid_size = 32,
	mouse_over = false,
	mouse_x = 0,
	mouse_y = 0,
	pos = { x = 0, y = 0 },
	offset = { x = 0, y = 0 },
	dragging = { acitve = false, diffx = 0, diffy = 0 },
	drag_vert = { acitve = false, diffx = 0, diffy = 0, index = 0 },
	bg_color = { 0.15, 0.15, 0.15, 1 },
	display = require("editor.ui.viewport"),
}

function Viewport:init()
	self.canvas = love.graphics.newCanvas(Window.width, Window.height)
end

function Viewport:center()
	if not Editor.loaded_project then return end

	local width, height = self.canvas:getDimensions()
	local gw = Editor.loaded_project.game_width
	local gh = Editor.loaded_project.game_height

	local sx = width / gw
	local sy = height / gh
	local scale = math.min(sx, sy)
	self.scale = scale

	local x = (width - (gw * scale))
	local y = (height - (gh * scale))
	self.offset.x = (x / 2)
	self.offset.y = (y / 2)
end

function Viewport:update_mouse()
	local mouse_pos = Input:get_mouse_position()
	self.mouse_x = ((mouse_pos.x - (self.pos.x + self.offset.x)) / self.scale)
	self.mouse_y = ((mouse_pos.y - (self.pos.y + self.offset.y)) / self.scale)
end

function Viewport:update()
	if not self.mouse_over then return end

	local mpos = Input:get_mouse_position()

	if Input:button_pressed(MOUSE_BUTTON.MIDDLE) then
		self.dragging.acitve = true
		self.dragging.diffx = mpos.x - self.offset.x
		self.dragging.diffy = mpos.y - self.offset.y
	end

	if Input:button_released(MOUSE_BUTTON.MIDDLE) then
		self.dragging.acitve = false
	end

	if self.dragging.acitve then
		self.offset.x = mpos.x - self.dragging.diffx
		self.offset.y = mpos.y - self.dragging.diffy
	end

	if Input:wheel_up() then self.scale = self.scale + 0.1 end

	if Input:wheel_down() then self.scale = self.scale - 0.1 end

	if Editor.selected_entity and Editor.selected_entity:is(Trigger) then
		self:edit_trigger(Editor.selected_entity --[[@as Trigger]])
	end

	self:update_mouse()
end

function Viewport:draw_scene()
	for _, entity in pairs(Editor.scenes.current.data.entities) do
		if entity.layer.active then
			entity:draw()

			if entity == Editor.selected_entity then
				if entity:is(Trigger) then
					---@cast entity Trigger
					Viewport:draw_trigger(entity)
				end
			end
		end
	end

	for _, layer in pairs(Editor.scenes.current.data.layers) do
		if layer.active and layer.draw ~= nil then layer.draw() end
	end
end

local function point_in_circle(px, py, cx, cy, r)
	local distance = math.sqrt((px - cx) ^ 2 + (py - cy) ^ 2)
	return distance <= r
end

---@param t Trigger
function Viewport:edit_trigger(t)
	local r = 6 / self.scale

	for i = 1, #t.verticies, 2 do
		local x = t.position.x + t.verticies[i]
		local y = t.position.y + t.verticies[i + 1]

		if point_in_circle(self.mouse_x, self.mouse_y, x, y, r) then
			if Input:button_pressed(MOUSE_BUTTON.LEFT) then
				self.drag_vert.acitve = true
				self.drag_vert.diffx = self.mouse_x - x
				self.drag_vert.diffy = self.mouse_y - y
				self.drag_vert.index = i
			end
		end

		if self.drag_vert.acitve then
			if self.drag_vert.index == i then
				t.verticies[i] = (self.mouse_x - self.drag_vert.diffx)
					- t.position.x
				t.verticies[i + 1] = (self.mouse_y - self.drag_vert.diffy)
					- t.position.y
			end
		end

		if Input:button_released(MOUSE_BUTTON.LEFT) then
			self.drag_vert.acitve = false
			t.tris = love.math.triangulate(t.verticies)
		end
	end
end

---@param t Trigger
function Viewport:draw_trigger(t)
	local r = 6 / self.scale

	love.graphics.push()
	love.graphics.translate(t.position.x, t.position.y)
	for i = 1, #t.verticies, 2 do
		local x = t.verticies[i]
		local y = t.verticies[i + 1]
		local nx = x
		local ny = y

		if i ~= #t.verticies - 1 then
			nx = t.verticies[i + 2]
			ny = t.verticies[i + 3]
		else
			nx = t.verticies[1]
			ny = t.verticies[2]
		end

		love.graphics.setColor(0.5, 0.5, 0.5, 1)
		love.graphics.line(x, y, nx, ny)

		if
			point_in_circle(
				self.mouse_x,
				self.mouse_y,
				t.position.x + x,
				t.position.y + y,
				r
			)
		then
			love.graphics.setColor(0, 1, 0, 1)
		else
			love.graphics.setColor(0.5, 0.5, 0.5, 1)
		end

		love.graphics.circle("fill", x, y, r)
	end
	love.graphics.pop()
end
