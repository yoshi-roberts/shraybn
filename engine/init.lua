Class = require("libs.class")

Engine = {
	layers = {},
}

require("engine.event")
require("engine.window")
require("engine.input")
require("engine.layer")

function Engine.init() end

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
end
