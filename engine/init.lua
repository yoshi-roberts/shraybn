require("libs.class")

local engine = {}

Event = require("engine.event")
Input = require("engine.input")

function engine.init()
	love.window.setMode(1280, 720, {
		vsync = false,
	})
end

function engine.update(dt)
	Input:update()
end

function engine.draw() end

return engine
