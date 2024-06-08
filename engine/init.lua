Object = require("libs.classic")
Vec2 = require("libs.vector")

local concord = require("libs.concord")
Entity = concord.entity
Component = concord.component
System = concord.system
World = concord.world
Components = concord.components

require("engine.imgui")

Engine = {
	layers = {},
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

	if failed then
		return false
	end

	concord.utils.loadNamespace("engine/components")

	timer.framerate = 60

	Assets:init()
	Assets:load("test-assets")

	Log.info("Engine initialized.")
	return true
end

function Engine:shutdown()
	for _, layer in pairs(self.layers) do
		if layer.detach ~= nil then
			layer.detach()
		end
	end
end

function Engine:update(dt)
	Assets:update()

	for _, layer in pairs(self.layers) do
		if layer.update ~= nil then
			layer.update(dt)
		end
	end

	Input:update()
end

function Engine:draw()
	for _, layer in pairs(self.layers) do
		if layer.draw ~= nil then
			layer.draw()
		end
	end
end
