require("engine")

---@diagnostic disable-next-line: duplicate-set-field
function love.load()
	if not Engine.init() then
		Log.fatal("Engine failed to initialize")
	end
	Window:init(1280, 720)

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
		local animals = Assets:get("image", "animals.png")
		love.graphics.draw(animals, 256, 256)
	end
end

function love.quit()
	Engine:shutdown()
end
