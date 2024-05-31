Class = require("libs.class")

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

	if failed then
		return false
	end

	timer.framerate = 70

	Log.info("Engine initialized.")
	return true
end

function Engine:update(dt)
	-- for _, layer in pairs(self.layers) do
	-- 	if layer.update ~= nil then
	-- 		layer:update()
	-- 	end
	-- end

	Input:update()
end

function Engine.draw() end

function Engine:new_layer(name, callbacks)
	table.insert(self.layers, Layer(name, callbacks))
	return self.layers[#self.layers]
end

function Engine:new_canvas(width, height, filter)
	table.insert(self.canvases, Canvas(width, height, filter))
	return self.canvases[#self.canvases]
end
