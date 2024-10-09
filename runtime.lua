require("engine")
require("engine.imgui")

---@diagnostic disable-next-line: duplicate-set-field
function love.load()
	Window:init(1280, 720)

	Assets:init("projects/NewProject", true)
	Assets:load()

	local default_scene = Scene("default_scene")
	default_scene:add_layer(Layer(require("ui_layer")))

	Engine:set_scene("default_scene")
end

---@diagnostic disable-next-line: duplicate-set-field
function love.update(dt)
	Engine:update(dt)
end

---@diagnostic disable-next-line: duplicate-set-field
function love.draw()
	Engine:draw()
end

---@diagnostic disable-next-line: duplicate-set-field
function love.quit()
	Engine:shutdown()
end
