require("libs.batteries.tablex")
local binser = require("libs.binser")

Vec2 = require("libs.batteries.vec2")
binser.register(Vec2, "Vec2")

local timer = require("engine.time")
local event = require("engine.event")
local assets = require("engine.assets")
local input = require("engine.input")
local log = require("libs.log")

---@class engine
local engine = {}

engine.canvases = {} ---@type engine.Canvas[]
engine.scenes = {} ---@type engine.Scene[]
engine.active_scene = nil ---@type engine.Scene

---@type event_callback
local function update_canvases(code, data)
	for _, canvas in pairs(engine.canvases) do
		canvas:update(data.width, data.height)
	end

	return false
end

function engine.init()
	timer.framerate = 60
	event.register(event.code.WINDOW_RESIZE, update_canvases)
end

log.info("Engine initialized.")

function engine.shutdown()
	engine.active_scene:shutdown()
end

function engine.update(dt)
	assets.update()
	engine.active_scene:update(dt)
	input.update()
end

function engine.draw()
	engine.active_scene:draw()
end

---@param canvas engine.Canvas
---@return engine.Canvas
function engine.add_canvas(canvas)
	table.insert(engine.canvases, canvas)
	return table.back(engine.canvases)
end

---@param scene engine.Scene
---@return engine.Scene
function engine.add_scene(scene)
	engine.scenes[scene.name] = scene
	return scene
end

function engine.set_scene(name)
	engine.active_scene = engine.scenes[name]
end

return engine
