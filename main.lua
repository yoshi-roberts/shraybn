require("engine")

local function ev_callback(code, sender, listener, data)
	return true
end

local function l_attach()
	print("Attached")
end

---@diagnostic disable-next-line: duplicate-set-field
function love.load()
	Engine.init()
	Window:init(1280, 720)

	Event:register(EVENT_CODE.MOUSE_MOVE, nil, ev_callback)

	Engine:new_layer("test_layer", {
		attach = l_attach,
	})
end

---@diagnostic disable-next-line: duplicate-set-field
function love.update(dt)
	if Input:button_pressed(MOUSE_BUTTON.LEFT) then
		print("LEFT")
	end

	if Input:key_pressed("a") then
		print("A")
	end

	Engine:update(dt)
end

---@diagnostic disable-next-line: duplicate-set-field
function love.draw()
	Engine.draw()
end
