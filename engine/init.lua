Vec2 = require("libs.vector")

local binser = require("libs.binser")
local assets = require("engine.assets")
local input = require("engine.input")
local log = require("libs.log")

local timer = require("engine.time")
timer.framerate = 60

---@class engine
local engine = {}

engine.canvases = {}
engine.scenes = {}
engine.active_scene = nil ---@type engine.Scene

function engine:init() end

-- Register metatables for serialization.
binser.register(Vec2, "Vec2")
-- binser.register(Object, "Object")
-- binser.register(Project, "Project")
-- binser.register(Scene, "Scene")
-- binser.register(Layer, "Layer")
-- binser.register(Entity, "Entity")
-- binser.register(Sprite, "Sprite")
-- binser.register(Trigger, "Trigger")

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
