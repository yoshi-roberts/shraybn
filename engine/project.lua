local Class = require("libs.class")
local nativefs = require("libs.nativefs")
local binser = require("libs.binser")
local log = require("libs.log")

---@class engine.Project: Class
local Project = Class:extend()

---@param name string
---@param width integer
---@param height integer
function Project:init(name, width, height)
	self.name = name
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

	return proj
end

---@param path string
function Project:save(path)
	local serialized = binser.serialize(self)

	if not nativefs.write(path .. "/" .. "proj.spd", serialized, #serialized) then
		log.error("Project data could not be written.")
	end
end

---@private
function Project:__tostring()
	return "Project"
end

return Project
