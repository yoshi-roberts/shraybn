SceneViewer = {
	canvas = nil,
}

local win_flags = Imgui.love.WindowFlags("NoTitleBar", "NoMove", "NoCollapse")

function SceneViewer:display()
	Imgui.Begin("Viewport", nil, nil)

	if self.canvas then
		local region = Imgui.GetContentRegionAvail()

		local width, height = self.canvas:getDimensions()
		local sx = region.x / width
		local sy = region.y / height
		local scale = math.min(sx, sy)

		love.graphics.setCanvas(self.canvas)

		love.graphics.clear(0.2, 0.2, 0.2, 1)
		love.graphics.setColor(1, 0, 0, 1)
		-- love.graphics.circle("fill", 32, 32, 12)
		love.graphics.rectangle("line", 12, 12, 48, 48 * 2)

		-- Grid.

		-- love.graphics.push()

		-- love.graphics.scale(gls, gls)

		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.circle("fill", 32, 32, 12)

		local gls = Window.width / (width * scale)
		local gs = 32 * gls
		local xt = math.ceil(width / gs)
		local yt = math.ceil(height / gs)

		love.graphics.setLineStyle("rough")
		for x = 1, xt, 1 do
			for y = 1, yt, 1 do
				local posx = (x - 1) * gs
				local posy = (y - 1) * gs
				love.graphics.setColor(1, 1, 1, 0.15)
				love.graphics.rectangle("line", posx, posy, gs, gs)
			end
		end

		-- love.graphics.pop()
		love.graphics.setLineStyle("smooth")
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setCanvas()

		local size = Imgui.ImVec2_Float(width * scale, height * scale)

		Imgui.SetCursorPos(Imgui.GetCursorPos() + (region - size) * 0.5)
		Imgui.Image(self.canvas, size)
	end

	Imgui.End()
end
