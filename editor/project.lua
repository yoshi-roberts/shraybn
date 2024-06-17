---@class Project
Project = {}

---@param name string
---@return table
function Project.new(name)
	local proj = {
		name = name,
		window_width = 1280,
		window_height = 720,
		game_width = 1280,
		game_height = 720,
	}

	return proj
end

---@param name string
---@return table
function Project.load(name)
	local contents = Nativefs.read(name .. "/" .. "proj.sep")
	local deserialized = Binser.deserialize(contents)

	return deserialized[1]
end

---@param project table
function Project.save(project) end
