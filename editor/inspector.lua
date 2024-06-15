Inspector = {
	selected_resource = nil,
	viewer_width = 256,
	viewer_height = 384,
	viewer_image = nil,
}

Inspector.bk_grid = love.graphics.newImage("editor/bk_grid.png")
Inspector.viewer_canvas = love.graphics.newCanvas(Inspector.viewer_width, Inspector.viewer_height)

function Inspector:display()
	Imgui.Begin("Inspector", nil)

	local win_width = Imgui.GetContentRegionAvail().x

	-- Resize the canvas if needed.
	if self.viewer_width ~= win_width then
		self.viewer_width = win_width
		self.viewer_canvas = love.graphics.newCanvas(self.viewer_width, self.viewer_height)
	end

	-- Draw grid to canvas.
	love.graphics.setCanvas(self.viewer_canvas)

	local ts = 32
	local xt = math.ceil(self.viewer_width / ts)
	local yt = math.ceil(self.viewer_height / ts)

	for x = 1, xt, 1 do
		for y = 1, yt, 1 do
			local xp = (x - 1) * ts
			local yp = (y - 1) * ts

			love.graphics.draw(self.bk_grid, xp, yp)
		end
	end

	love.graphics.setCanvas()

	local size = Imgui.ImVec2_Float(self.viewer_canvas:getDimensions())
	Imgui.Image(self.viewer_canvas, size)

	-- if Assets:loaded() and selected_asset ~= 0 then
	-- 	local img = Assets:get("image", selected_asset)
	-- 	local size = Imgui.ImVec2_Float(img:getDimensions())
	-- 	Imgui.Image(img, size)
	-- end

	Imgui.End()
end
