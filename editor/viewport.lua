Viewport = {
	canvas = nil,
	scale = 1,
	grid_size = 32,
	pos = { x = 0, y = 0 },
	offset = { x = 0, y = 0 },
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

	local x = width - gw
	local y = height - gh
	self.offset.x = x / 2
	self.offset.y = y / 2
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
	local scale_percentage = self.scale * 100
	Imgui.Text(scale_percentage .. "%%")

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

	love.graphics.setCanvas(self.canvas)
	love.graphics.push()

	love.graphics.clear(self.bg_color)

	love.graphics.translate(self.offset.x, self.offset.y)
	-- love.graphics.scale(self.scale, self.scale)

	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.circle("fill", 256 * 2, 256, 64)

	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.line(-width, 0, width, 0)
	love.graphics.setColor(1, 1, 0, 1)
	love.graphics.line(0, -height, 0, height)

	if Editor.loaded_project then
		love.graphics.setColor(1, 1, 1, 1)

		if Editor.current_scene then
			for k, layer in pairs(Editor.current_scene.layers) do
				if layer.type == "image" and layer.image then
					love.graphics.draw(layer.image.resource)
				end
			end
		end

		love.graphics.rectangle("line", 0, 0, Editor.loaded_project.game_width, Editor.loaded_project.game_height)
	end

	love.graphics.pop()

	-- Grid.

	local gs = self.grid_size * self.scale
	local xt = math.ceil(Window.width / gs)
	local yt = math.ceil(Window.height / gs)

	love.graphics.setColor(1, 1, 1, 0.15)
	for x = 1, xt, 1 do
		for y = 1, yt, 1 do
			local posx = (x - 1) * gs
			local posy = (y - 1) * gs
			love.graphics.rectangle("line", posx, posy, gs, gs)
		end
	end

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setCanvas()

	local size = Imgui.ImVec2_Float(self.canvas:getDimensions())

	-- Imgui.SetCursorPos(Imgui.GetCursorPos() + (region - size) * 0.5)
	Imgui.Image(self.canvas, size)

	Imgui.End()
end
