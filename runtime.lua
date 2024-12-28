local Scene = require("engine.scene")
local Layer = require("engine.layer")
local Camera = require("engine.camera")
local engine = require("engine")
local window = require("engine.window")
local input = require("engine.input")

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
	if input.key_down("d") then
		cam.position.x = cam.position.x + 1
	end

	if input.key_down("space") then
		local mpos = input.get_mouse_position()
		cam:zoom_to(cam:to_world(mpos), 0.1)
	end
end

---@diagnostic disable-next-line: duplicate-set-field
function love.draw()
	cam:attach()
	love.graphics.circle("fill", 32, 32, 32)
	local mpos = input.get_mouse_position()
	local spos = cam:to_world(mpos)
	love.graphics.circle("fill", spos.x, spos.y, 32)
	cam:detach()
	engine.draw()
end

---@diagnostic disable-next-line: duplicate-set-field
function love.quit()
	engine.shutdown()
end
