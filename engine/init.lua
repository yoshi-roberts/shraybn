Object = require("libs.classic")
Vec2 = require("libs.vector")
Nativefs = require("libs.nativefs")

local concord = require("libs.concord")
Entity = concord.entity
Component = concord.component
System = concord.system
World = concord.world
Components = concord.components

Engine = {
	---@type {[string]: Scene}
	scenes = {},
	---@type Scene
	active_scene = nil,

	canvases = {},
}

local timer = require("engine.time")
Log = require("libs.log")

require("engine.canvas")

local function load_module(module)
	local str = module:sub(1, 1):upper() .. module:sub(2, #module)
	local failed = false

	if not require("engine." .. module) then
		Log.error(str .. " system initialization failed.")
		failed = true
	end

	Log.info(str .. " system initialized.")
	return failed
end

function Engine.init()
	local failed = false

	failed = load_module("event")
	failed = load_module("window")
	failed = load_module("input")
	failed = load_module("layer")
	failed = load_module("assets")
	failed = load_module("scene")

	if failed then
		return false
	end

	timer.framerate = 60
	concord.utils.loadNamespace("engine/components")

	Assets:init("test-assets")
	Assets:load()

	Log.info("Engine initialized.")
	return true
end

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
