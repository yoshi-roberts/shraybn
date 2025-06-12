local Class = require("libs.class")
local nativefs = require("libs.nativefs")
local binser = require("libs.binser")
local log = require("libs.log")

local engine = require("engine")
local assets = require("engine.assets")
local Scene = require("engine.scene")
local Layer = require("engine.layer")
local Canvas = require("engine.canvas")
local Camera = require("engine.camera")

---@class engine.Project: Class
local Project = Class:extend()

---@param name string
---@param path string
---@param width integer
---@param height integer
function Project:init(name, path, width, height)
	self.name = name
	self.path = path
	self.window_width = width or 1280
	self.window_height = height or 720
	self.game_width = 1280
	self.game_height = 720
	self.main_scene = nil
	self.file_path = nil
end

---@param path string
---@return engine.Project
function Project.load(path)
	local contents = nativefs.read(path .. "/" .. "proj.spd")
	local deserialized = binser.deserialize(contents)

	local proj = deserialized[1]
	proj.file_path = path

	nativefs.setWorkingDirectory(proj.file_path)

	return proj
end

---@param path string
function Project:save(path)
	local serialized = binser.serialize(self)

	if not nativefs.write(path .. "/" .. "proj.spd", serialized, #serialized) then
		log.error("Project data could not be written.")
	end
end

function Project:set()
	engine.loaded_project = self
	assets.init(self.file_path, true)
	assets.load()

	local path = "projects/" .. self.name .. "/" .. self.main_scene
	local main_scn_file = Scene.load(path)
	local main_scn = engine.add_scene(main_scn_file)

	engine.game_canvas = Canvas:new(self.game_width, self.game_height, "fit")
	engine.camera = Camera:new(engine.game_canvas)

	engine.add_canvas(engine.game_canvas)
	engine.set_scene(main_scn.name)
end

---@private
function Project:__tostring()
	return "Project"
end

return Project
