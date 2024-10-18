local trigger = require("editor.trigger-edit") --[[@as trigger]]

local function display()
	Imgui.Begin("Viewport", nil, nil)

	if Imgui.Button(FONT_ICONS.ICON_ARROWS_ALT) then
		Viewport:center()
	end

	Imgui.SameLine()
	if Imgui.Button(FONT_ICONS.ICON_MINUS) then
		Viewport.scale = Viewport.scale - 0.1
	end

	Imgui.SameLine()
	local scale_percentage = math.floor(Viewport.scale * 100)
	if Imgui.Button(scale_percentage .. "%") then
		Viewport.scale = 1
	end

	Imgui.SameLine()
	if Imgui.Button(FONT_ICONS.ICON_PLUS) then
		Viewport.scale = Viewport.scale + 0.1
	end

	local region = Imgui.GetContentRegionAvail()

	local width, height = Viewport.canvas:getDimensions()

	if region.x ~= width or region.y ~= height then
		if region.x > 0 and region.y > 0 then
			Viewport.canvas = love.graphics.newCanvas(region.x, region.y)
		end
	end
	width, height = Viewport.canvas:getDimensions()

	local win_pos = Imgui.GetWindowPos()
	local cursor_pos = Imgui.GetCursorPos()
	Viewport.pos.x = win_pos.x + cursor_pos.x
	Viewport.pos.y = win_pos.y + cursor_pos.y

	-- Start rendering to viewport canvas.
	love.graphics.setCanvas(Viewport.canvas)
	love.graphics.push()

	love.graphics.clear(Viewport.bg_color)

	love.graphics.translate(Viewport.offset.x, Viewport.offset.y)
	love.graphics.scale(Viewport.scale, Viewport.scale)

	if Editor.loaded_project then
		love.graphics.setColor(1, 1, 1, 1)

		if Editor.scenes.current then
			Viewport:draw_scene()
			-- Editor.scenes.current.data:draw()
		end
	end

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.circle("fill", Viewport.mouse_x, Viewport.mouse_y, 12)

	love.graphics.pop()

	-- Grid.

	love.graphics.push()
	love.graphics.translate(Viewport.offset.x, Viewport.offset.y)

	love.graphics.setLineStyle("rough")

	if Editor.loaded_project then
		love.graphics.rectangle(
			"line",
			0,
			0,
			Editor.loaded_project.game_width * Viewport.scale,
			Editor.loaded_project.game_height * Viewport.scale
		)
	end

	local gs = Viewport.grid_size * Viewport.scale

	local xt = math.ceil((Viewport.canvas:getWidth() - Viewport.offset.x) / gs)
	local yt = math.ceil((Viewport.canvas:getHeight() - Viewport.offset.y) / gs)

	local start_x = math.floor(-Viewport.offset.x / gs)
	local start_y = math.floor(-Viewport.offset.y / gs)

	love.graphics.setColor(1, 1, 1, 0.05)
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

	local size = Imgui.ImVec2_Float(Viewport.canvas:getDimensions())
	Imgui.Image(Viewport.canvas, size)

	Viewport.mouse_over = Imgui.IsItemHovered()

	Imgui.End()
end

return display
