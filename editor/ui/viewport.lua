local editor = require("editor")
local input = require("engine.input")
local font_icon = require("editor.font_icons")
local imgui = require("engine.imgui")

---@param viewport editor.viewport
local function controls(viewport)
	if imgui.Button(font_icon.ICON_ARROWS_ALT) then
		viewport.center()
	end

	imgui.SameLine()
	if imgui.Button(font_icon.ICON_MINUS) then
		viewport.camera.scale = viewport.camera.scale - 0.1
	end

	imgui.SameLine()
	local scale_percentage = math.floor(viewport.camera.scale * 100)
	if imgui.Button(scale_percentage .. "%") then
		viewport.camera.scale = 1
	end

	imgui.SameLine()
	if imgui.Button(font_icon.ICON_PLUS) then
		viewport.camera.scale = viewport.camera.scale + 0.1
	end
end

-- TODO: This needs to be changed for the new camera system.
---@param viewport editor.viewport
local function grid(viewport)
	viewport.canvas:attach()
	love.graphics.push()
	love.graphics.translate(-viewport.camera.position.x, -viewport.camera.position.y)

	love.graphics.setLineStyle("rough")

	if editor.loaded_project then
		love.graphics.rectangle(
			"line",
			0,
			0,
			editor.loaded_project.game_width * viewport.camera.scale,
			editor.loaded_project.game_height * viewport.camera.scale
		)
	end

	-- local gs = viewport.grid_size * viewport.scale
	--
	-- local cwidth, cheight = viewport.camera.canvas:get_size()
	-- local xt = math.ceil((cwidth - viewport.camera.position.x) / gs)
	-- local yt = math.ceil((cheight - viewport.camera.position.y) / gs)
	--
	-- local start_x = math.floor(-viewport.camera.position.x / gs)
	-- local start_y = math.floor(-viewport.camera.position.x / gs)
	--
	-- love.graphics.setColor(1, 1, 1, 0.05)
	-- for x = start_x, xt, 1 do
	-- 	for y = start_y, yt, 1 do
	-- 		local posx = (x * gs)
	-- 		local posy = (y * gs)
	-- 		love.graphics.rectangle("line", posx, posy, gs, gs)
	-- 	end
	-- end

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setLineStyle("smooth")

	love.graphics.pop()
	viewport.canvas:detach()
end

---@param viewport editor.viewport
local function display(viewport)
	imgui.Begin("Viewport", nil, viewport.win_flags)

	controls(viewport)

	local style = imgui.GetStyle()
	local padding = style.WindowPadding.x
	local region = imgui.GetContentRegionAvail()
	local width, height = viewport.canvas:get_size()

	if region.x ~= width or region.y ~= height then
		if region.x > 0 and region.y > 0 then
			viewport.canvas:resize(region.x + padding * 2, region.y + padding)
		end
	end
	width, height = viewport.canvas:get_size()

	viewport.camera:attach()

	if editor.loaded_project then
		love.graphics.setColor(1, 1, 1, 1)

		if editor.scenes.current then
			viewport.draw_scene()
			-- Editor.scenes.current.data:draw()
		end
	end

	local cpos = viewport.camera:get_position()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.circle("fill", 0, 0, 12)
	love.graphics.circle("fill", cpos.x, cpos.y, 12)

	love.graphics.setColor(1, 0, 0, 1)

	local mpos = viewport.camera:get_mouse_position()
	love.graphics.circle("fill", mpos.x, mpos.y, 8)

	-- grid(viewport)

	love.graphics.setColor(1, 1, 1, 1)
	viewport.camera:detach()

	grid(viewport)

	local cursor_pos = imgui.GetCursorPos()

	local size = imgui.ImVec2_Float(viewport.canvas:get_size())
	imgui.SetCursorPosX(cursor_pos.x - padding)

	local win_pos = imgui.GetWindowPos()
	cursor_pos = imgui.GetCursorPos()

	local cx = win_pos.x + cursor_pos.x
	local cy = win_pos.y + cursor_pos.y
	viewport.canvas:set_position(cx, cy)

	love.graphics.circle("fill", cx, cy, 16)

	imgui.Image(viewport.canvas.target, size)

	viewport.is_mouse_over = imgui.IsItemHovered()

	imgui.End()
end

return display
