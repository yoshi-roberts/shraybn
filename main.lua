Engine = require("engine")

local function ev_callback(code, sender, listener, data)
	print(data)
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

function love.keypressed(key, scancode, isrepeat)
	Event.fire(Event.code.EVENT_KEY_PRESS, nil, key)
end

---@diagnostic disable-next-line: duplicate-set-field
function love.draw()
	Engine.draw()
end
