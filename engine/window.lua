Window = {
	title = "",
	width = 0,
	height = 0,
}

function Window:init(width, height, title)
	love.window.setMode(width or 0, height or 0, {
		vsync = false,
		resizable = true,
	})

	love.window.setTitle(self.title or "Shraybn")

	self.title = title or love.window.getTitle()
	self.width = width or love.graphics.getWidth()
	self.height = height or love.graphics.getHeight()
end

function Window:process_resize(width, height)
	if self.width ~= width or self.height ~= height then
		self.width = width
		self.height = height

		for _, canvas in pairs(Engine.canvases) do
			canvas:update()
		end

		Event:fire(EVENT_CODE.WINDOW_RESIZE, { width, height })
	end
end

return true
