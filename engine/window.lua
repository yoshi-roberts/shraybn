---@class engine.window
local window = {
	title = "",
	width = 0,
	height = 0,
}

---@param width integer
---@param height integer
---@param title string?
function window.init(width, height, title)
	love.window.setMode(width or 0, height or 0, {
		vsync = false,
		resizable = true,
	})

	love.window.setTitle(window.title or "Shraybn")

	window.title = title or love.window.getTitle()
	window.width = width or love.graphics.getWidth()
	window.height = height or love.graphics.getHeight()
end

---@param width integer
---@param height integer
---@return boolean
function window.process_resize(width, height)
	if window.width ~= width or window.height ~= height then
		window.width = width
		window.height = height

		-- TODO: Needs to be handled by the engine module.
		-- for _, canvas in pairs(engine.canvases) do
		-- 	canvas:update()
		-- end

		return true
	end

	return false
end

return window
