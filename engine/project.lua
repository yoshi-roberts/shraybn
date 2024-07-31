---@class Project
Project = Object:extend()

---@param name string
---@param width integer
---@param height integer
function Project:new(name, width, height)
	self.name = name
	self.window_width = width or 1280
	self.window_height = height or 720
	self.game_width = 1280
	self.game_height = 720
end

---@param path string
---@return Project
function Project.load(path)
	local contents = Nativefs.read(path .. "/" .. "proj.spd")
	local deserialized = Binser.deserialize(contents)

	return deserialized[1]
end

function Project:save()
	local serialized = Binser.serialize(self)

	if not Nativefs.write("proj.spd", serialized, #serialized) then
		Log.error("Project data could not be written.")
	end
end

return true
