local editor = require "editor"
local font_icon = require "editor.font_icons"
local imgui = require "engine.imgui"

---@param viewport editor.viewport
local function display(viewport)
	imgui.Begin("Viewport", nil, nil)

	if imgui.Button(font_icon.ICON_ARROWS_ALT) then
		viewport.center()
	end

	imgui.SameLine()
	if imgui.Button(font_icon.ICON_MINUS) then
		viewport.scale = viewport.scale - 0.1
	end

	imgui.SameLine()
	local scale_percentage = math.floor(viewport.scale * 100)
	if imgui.Button(scale_percentage .. "%") then
		viewport.scale = 1
	end

	imgui.SameLine()
	if imgui.Button(font_icon.ICON_PLUS) then
		viewport.scale = viewport.scale + 0.1
	end

	local region = imgui.GetContentRegionAvail()

	local width, height = viewport.canvas:getDimensions()

	if region.x ~= width or region.y ~= height then
		if region.x > 0 and region.y > 0 then
			viewport.canvas = love.graphics.newCanvas(region.x, region.y)
		end
	end
	width, height = viewport.canvas:getDimensions()

	local win_pos = imgui.GetWindowPos()
	local cursor_pos = imgui.GetCursorPos()
	viewport.pos.x = win_pos.x + cursor_pos.x
	viewport.pos.y = win_pos.y + cursor_pos.y

	-- Start rendering to viewport canvas.
	love.graphics.setCanvas(viewport.canvas)
	love.graphics.push()

	love.graphics.clear(viewport.bg_color)

	love.graphics.translate(viewport.offset.x, viewport.offset.y)
	love.graphics.scale(viewport.scale, viewport.scale)

	if editor.loaded_project then
		love.graphics.setColor(1, 1, 1, 1)

		if editor.scenes.current then
			viewport.draw_scene()
			-- Editor.scenes.current.data:draw()
		end
	end

	love.graphics.setColor(1, 1, 1, 1)
	-- love.graphics.circle("fill", Viewport.mouse_x, Viewport.mouse_y, 12)

	love.graphics.pop()

	-- Grid.

	love.graphics.push()
	love.graphics.translate(viewport.offset.x, viewport.offset.y)

	love.graphics.setLineStyle("rough")

	if editor.loaded_project then
		love.graphics.rectangle(
			"line",
			0,
			0,
			editor.loaded_project.game_width * viewport.scale,
			editor.loaded_project.game_height * viewport.scale
		)
	end

	local gs = viewport.grid_size * viewport.scale

	local xt = math.ceil((viewport.canvas:getWidth() - viewport.offset.x) / gs)
	local yt = math.ceil((viewport.canvas:getHeight() - viewport.offset.y) / gs)

	local start_x = math.floor(-viewport.offset.x / gs)
	local start_y = math.floor(-viewport.offset.y / gs)

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

	local size = imgui.ImVec2_Float(viewport.canvas:getDimensions())
	imgui.Image(viewport.canvas, size)

	viewport.mouse_over = imgui.IsItemHovered()

	imgui.End()
end

return display
