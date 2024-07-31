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

---@param name string
---@return Project
function Project:load(name)
	local contents = Nativefs.read(name .. "/" .. "proj.spd")
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
