local engine = require("engine")
local input = require("engine.input")
local Scene = require("engine.scene")
local Layer = require("engine.layer")
local window = require("engine.window")

local Canvas = require("engine.canvas")
local Camera = require("engine.camera")

local canvas ---@type engine.Canvas
local camera ---@type engine.Camera

---@diagnostic disable-next-line: duplicate-set-field
function love.load()
	engine.init()
	window.init(1280, 720)

	canvas = Canvas:new(480, 270, "fit")
	engine.add_canvas(canvas)
	camera = Camera:new(canvas)

	local default_scene = engine.add_scene(Scene:new("default_scene"))
	default_scene:add_layer(Layer:new(require("ui_layer")))

	engine.set_scene("default_scene")
end

---@diagnostic disable-next-line: duplicate-set-field
function love.update(dt)
	engine.update(dt)
end

---@diagnostic disable-next-line: duplicate-set-field
function love.draw()
	canvas:attach()

	love.graphics.clear(0.5, 0.5, 0.5)
	local mpos = canvas:screen_to_canvas(input:get_mouse_position())
	love.graphics.circle("fill", mpos.x, mpos.y, 8)

	canvas:detach()
	canvas:draw()

	engine.draw()
end

---@diagnostic disable-next-line: duplicate-set-field
function love.quit()
	engine.shutdown()
end
