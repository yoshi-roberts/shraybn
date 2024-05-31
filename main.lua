require("engine")

local can

---@diagnostic disable-next-line: duplicate-set-field
function love.load()
	if not Engine.init() then
		Log.fatal("Engine failed to initialize")
	end
	Window:init(1280, 720)

	require("imgui_layer")

	can = Engine:new_canvas(480, 270, "nearest")
end

---@diagnostic disable-next-line: duplicate-set-field
function love.update(dt)
	Engine:update(dt)
end

---@diagnostic disable-next-line: duplicate-set-field
function love.draw()
	Engine:draw()

	can:start()
	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.circle("fill", 16, 16, 12)
	can:finish()

	can:draw()
end

function love.quit()
	Engine:shutdown()
end
