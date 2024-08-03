--
-- Global libraries.
--
Object = require("libs.classic")
Vec2 = require("libs.vector")
Nativefs = require("libs.nativefs")
Binser = require("libs.binser")
Log = require("libs.log")

local timer = require("engine.time")
timer.framerate = 60

local failed = false
local function load_module(module)
	local str = module:sub(1, 1):upper() .. module:sub(2, #module)

	if not require("engine." .. module) then
		Log.error(str .. " system initialization failed.")
		failed = true
	end

	Log.info(str .. " system initialized.")
	return failed
end

--
-- Engine class.
--
Engine = Object:extend()

Engine.canvases = {}
Engine.scenes = {}
Engine.actie_scene = nil

--
-- Load modules.
--
load_module("event")
load_module("window")
load_module("input")
load_module("layer")
load_module("assets")
load_module("scene")
load_module("project")

require("engine.entity")
require("engine.sprite")
require("engine.trigger")

if failed then
	Log.fatal("Engine failed to initialize")
	return false
end

--
-- Register classes for serialization.
--
Binser.register(Object, "Object")
Binser.register(Project, "Project")
Binser.register(Scene, "Scene")
Binser.register(Layer, "Layer")
Binser.register(Entity, "Entity")
Binser.register(Sprite, "Sprite")
Binser.register(Trigger, "Trigger")

Log.info("Engine initialized.")

function Engine:shutdown()
	self.active_scene:shutdown()
end

function Engine:update(dt)
	Assets:update()
	self.active_scene:update(dt)
	Input:update()
end

function Engine:draw()
	self.active_scene:draw()
end

function Engine:set_scene(name)
	self.active_scene = self.scenes[name]
end
