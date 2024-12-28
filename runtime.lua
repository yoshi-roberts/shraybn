local Scene = require("engine.scene")
local Layer = require("engine.layer")
local Camera = require("engine.camera")
local engine = require("engine")
local window = require("engine.window")

local cam = nil ---@type engine.Camera

---@diagnostic disable-next-line: duplicate-set-field
function love.load()
	engine.init()
	window.init(1280, 720)

	cam = Camera:new()

	local default_scene = engine.add_scene(Scene:new("default_scene"))
	default_scene:add_layer(Layer:new(require("ui_layer")))

	engine.set_scene("default_scene")
end

---@diagnostic disable-next-line: duplicate-set-field
function love.update(dt)
	engine.update(dt)
	cam.position.x = cam.position.x + 1
	cam.position.y = cam.position.y + 1
end

---@diagnostic disable-next-line: duplicate-set-field
function love.draw()
	cam:attach()
	love.graphics.circle("fill", 0, 0, 32)
	cam:detach()
	engine.draw()
end

---@diagnostic disable-next-line: duplicate-set-field
function love.quit()
	engine.shutdown()
end
