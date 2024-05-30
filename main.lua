Engine = require("engine")

local function ev_callback(code, sender, listener, data)
	print(data[1], data[2])
end

---@diagnostic disable-next-line: duplicate-set-field
function love.load()
	Engine.init()

	Event.register(Event.code.EVENT_MOUSE_MOVE, nil, ev_callback)
end

---@diagnostic disable-next-line: duplicate-set-field
function love.update(dt)
	if Input:button_pressed(1) then
		print("LEFT")
	end

	if Input:key_pressed("a") then
		print("A")
	end

	Engine.update(dt)
end

---@diagnostic disable-next-line: duplicate-set-field
function love.draw()
	Engine.draw()
end
