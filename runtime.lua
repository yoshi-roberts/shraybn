require("engine")
require("engine.imgui")

---@diagnostic disable-next-line: duplicate-set-field
function love.load()
	if not Engine.init() then
		Log.fatal("Engine failed to initialize")
	end
	Window:init(1280, 720)

	Scene("default_scene")
	Engine:set_scene("default_scene")

	require("ui_layer")
end

---@diagnostic disable-next-line: duplicate-set-field
function love.update(dt)
	Engine:update(dt)
end

---@diagnostic disable-next-line: duplicate-set-field
function love.draw()
	Engine:draw()

	if Assets:loaded() then
		local items = Assets:get("image", "rogues.items")
		love.graphics.draw(items, 256, 256)
	end
end

function love.quit()
	Engine:shutdown()
end
