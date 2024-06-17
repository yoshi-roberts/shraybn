Inspector = {
	selected_resource = nil,
	viewer_width = 256,
	viewer_height = 384,
	viewer_image = nil,
}

Inspector.bk_grid = love.graphics.newImage("editor/bk_grid.png")
Inspector.viewer_canvas = love.graphics.newCanvas(Inspector.viewer_width, Inspector.viewer_height)

local function get_mem(bytes)
	local number = nil
	local suffix = "B"

	if bytes >= math.pow(10, 9) then
		suffix = "GB"
		number = bytes / math.pow(10, 9)
	elseif bytes >= math.pow(10, 6) then
		suffix = "MB"
		number = bytes / math.pow(10, 6)
	elseif bytes >= 1000 then
		suffix = "KB"
		number = bytes / 1000
	end

	return number .. suffix
end

function Inspector:display()
	Imgui.Begin("Inspector", nil)

	local win_width = Imgui.GetContentRegionAvail().x

	-- Resize the canvas if needed.
	if self.viewer_width ~= win_width then
		self.viewer_width = win_width
		self.viewer_canvas = love.graphics.newCanvas(self.viewer_width, self.viewer_height)
	end

	if self.viewer_image then
		love.graphics.setCanvas(self.viewer_canvas)

		local tile_size = 32
		local x_tiles = math.ceil(self.viewer_width / tile_size)
		local y_tiles = math.ceil(self.viewer_height / tile_size)

		-- Draw grid to canvas.
		for x = 1, x_tiles, 1 do
			for y = 1, y_tiles, 1 do
				local pos_x = (x - 1) * tile_size
				local pos_y = (y - 1) * tile_size

				love.graphics.draw(self.bk_grid, pos_x, pos_y)
			end
		end

		local img = self.viewer_image.resource

		local scale_x = self.viewer_canvas:getWidth() / img:getWidth()
		local scale_y = self.viewer_canvas:getHeight() / img:getHeight()
		local scale = math.min(scale_x, scale_y)

		local width = img:getWidth() * scale
		local height = img:getHeight() * scale
		local x = (self.viewer_canvas:getWidth() / 2) - (width / 2)
		local y = (self.viewer_canvas:getHeight() / 2) - (height / 2)

		love.graphics.draw(img, x, y, 0, scale)

		love.graphics.setCanvas()

		Imgui.TextWrapped(self.viewer_image.path)

		local size = Imgui.ImVec2_Float(self.viewer_canvas:getDimensions())
		Imgui.Image(self.viewer_canvas, size)
	end

	Imgui.End()
end
