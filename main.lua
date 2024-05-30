Engine = require("engine")

local function ev_callback(code, sender, listener)
	print(code)
	print(sender)
	print(listener)
end

---@diagnostic disable-next-line: duplicate-set-field
function love.load()
	Engine.init()

	Event.register(Event.code.EVENT_KEY_PRESS, nil, ev_callback)
end

---@diagnostic disable-next-line: duplicate-set-field
function love.update(dt)
	Engine.update(dt)
end

---@diagnostic disable-next-line: duplicate-set-field
function love.draw()
	Engine.draw()
end
