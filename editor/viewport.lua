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
	bg_color = { 0.15, 0.15, 0.15, 1 },
}

local win_flags = Imgui.love.WindowFlags("NoTitleBar", "NoMove", "NoCollapse")

function Viewport:init()
	self.canvas = love.graphics.newCanvas(Window.width, Window.height)
end

function Viewport:center()
	if not Editor.loaded_project then
		return
	end

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
	if self.mouse_over then
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

		if Input:wheel_up() then
			self.scale = self.scale + 0.1
		end

		if Input:wheel_down() then
			self.scale = self.scale - 0.1
		end
	end

	self:update_mouse()
end

function Viewport:display()
	Imgui.Begin("Viewport", nil, nil)

	if Imgui.Button(FONT_ICONS.ICON_ARROWS_ALT) then
		self:center()
	end

	Imgui.SameLine()
	if Imgui.Button(FONT_ICONS.ICON_MINUS) then
		self.scale = self.scale - 0.1
	end

	Imgui.SameLine()
	local scale_percentage = math.floor(self.scale * 100)
	if Imgui.Button(scale_percentage .. "%") then
		self.scale = 1
	end

	Imgui.SameLine()
	if Imgui.Button(FONT_ICONS.ICON_PLUS) then
		self.scale = self.scale + 0.1
	end

	local region = Imgui.GetContentRegionAvail()

	local width, height = self.canvas:getDimensions()

	if region.x ~= width or region.y ~= height then
		if region.x > 0 and region.y > 0 then
			self.canvas = love.graphics.newCanvas(region.x, region.y)
		end
	end
	width, height = self.canvas:getDimensions()

	local win_pos = Imgui.GetWindowPos()
	local cursor_pos = Imgui.GetCursorPos()
	self.pos.x = win_pos.x + cursor_pos.x
	self.pos.y = win_pos.y + cursor_pos.y

	-- Start rendering to viewport canvas.
	love.graphics.setCanvas(self.canvas)
	love.graphics.push()

	love.graphics.clear(self.bg_color)

	love.graphics.translate(self.offset.x, self.offset.y)
	love.graphics.scale(self.scale, self.scale)

	if Editor.loaded_project then
		love.graphics.setColor(1, 1, 1, 1)

		if Editor.current_scene then
			-- Render scene layers.
			for k, layer in pairs(Editor.current_scene.layers) do
				if not layer.visible then
					goto continue
				end

				if layer.type == "image" and layer.image then
					local key = Util.path_to_key(layer.image)
					self.image = Assets:get("image", key)
					love.graphics.draw(self.image.resource)
				end

				::continue::
			end
		end
	end

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.circle("fill", self.mouse_x, self.mouse_y, 12)

	love.graphics.pop()

	-- Grid.

	love.graphics.push()
	love.graphics.translate(self.offset.x, self.offset.y)

	love.graphics.setLineStyle("rough")

	if Editor.loaded_project then
		love.graphics.rectangle(
			"line",
			0,
			0,
			Editor.loaded_project.game_width * self.scale,
			Editor.loaded_project.game_height * self.scale
		)
	end

	local gs = self.grid_size * self.scale

	local xt = math.ceil((self.canvas:getWidth() - self.offset.x) / gs)
	local yt = math.ceil((self.canvas:getHeight() - self.offset.y) / gs)

	local start_x = math.floor(-self.offset.x / gs)
	local start_y = math.floor(-self.offset.y / gs)

	love.graphics.setColor(1, 1, 1, 0.15)
	for x = start_x, xt, 1 do
		for y = start_y, yt, 1 do
			local posx = (x * gs)
			local posy = (y * gs)
			love.graphics.rectangle("line", posx, posy, gs, gs)
		end
	end

	love.graphics.setLineStyle("smooth")
	love.graphics.pop()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setCanvas()

	local size = Imgui.ImVec2_Float(self.canvas:getDimensions())
	Imgui.Image(self.canvas, size)

	self.mouse_over = Imgui.IsItemHovered()

	Imgui.End()
end
