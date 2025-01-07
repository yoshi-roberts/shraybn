require("libs.batteries.tablex")
local binser = require("libs.binser")

Vec2 = require("libs.batteries.vec2")
binser.register(Vec2, "Vec2")

local timer = require("engine.time")
local event = require("engine.event")
local assets = require("engine.assets")
local input = require("engine.input")
local log = require("libs.log")

local Scene = require("engine.scene")
local Canvas = require("engine.canvas")
local Camera = require("engine.camera")

---@class engine
---@field init function
---@field update function
---@field draw function
local engine = {}

engine.canvases = {} ---@type engine.Canvas[]
engine.scenes = {} ---@type engine.Scene[]
engine.active_scene = nil ---@type engine.Scene

engine.camera = nil ---@type engine.Camera
engine.game_canvas = nil ---@type engine.Canvas

local function register_class(name)
	local class = require("engine." .. name)
	local type = name:sub(1, 1):upper() .. name:sub(2, #name)
	binser.register(class, type)
end

---@type event.callback
local function update_canvases(code, data)
	for _, canvas in pairs(engine.canvases) do
		canvas:update(data.width, data.height)
	end

	return false
end

---@param args table
function engine._init(args)
	timer.framerate = 60
	event.register(event.code.WINDOW_RESIZE, update_canvases)

	register_class("camera")
	register_class("canvas")
	register_class("entity")
	register_class("layer")
	register_class("project")
	register_class("scene")
	register_class("sprite")
	register_class("trigger")

	if engine.init then
		engine.init(args)
	end

	log.info("Engine initialized.")
end

function engine.shutdown()
	if engine.active_scene then
		engine.active_scene:shutdown()
	end

	log.info("Engine shutdown.")
end

function engine._update(dt)
	assets.update()

	if engine.active_scene then
		engine.active_scene:update(dt)
	end

	if engine.update then
		engine.update()
	end

	input.update()
end

function engine._draw()
	if engine.camera then
		engine.camera:attach()
	end

	if engine.active_scene then
		engine.active_scene:draw()
	end

	if engine.draw then
		engine.draw()
	end

	if engine.camera then
		engine.camera:detach()
		engine.camera:draw()
	end
end

---@param project engine.Project
function engine.set_project(project)
	assets.init(project.file_path, true)
	assets.load()

	local scn = Scene.load("projects/" .. project.main_scene)
	local main_scene = engine.add_scene(scn)

	engine.game_canvas = Canvas:new(project.game_width, project.game_height, "fit")
	engine.camera = Camera:new(engine.game_canvas)

	engine.add_canvas(engine.game_canvas)

	engine.set_scene(scn.name)
end

---@param canvas engine.Canvas
---@return engine.Canvas
function engine.add_canvas(canvas)
	table.insert(engine.canvases, canvas)
	return table.back(engine.canvases)
end

---@param scene engine.Scene
---@return engine.Scene
function engine.add_scene(scene)
	engine.scenes[scene.name] = scene
	return scene
end

function engine.set_scene(name)
	engine.active_scene = engine.scenes[name]
end

function love.load(args)
	engine._init(args)
end

function love.update(dt)
	engine._update(dt)
end

function love.draw()
	engine._draw()
end

function love.quit()
	engine.shutdown()
end

return engine
