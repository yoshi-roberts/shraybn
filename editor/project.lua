Project = {}

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

function Project.load(name)
	Nativefs.setWorkingDirectory("projects/" .. name)
	local contents = Nativefs.read("proj.sep")
	local deserialized = Binser.deserialize(contents)
	local proj = deserialized[1]
end

function Project.save(project) end
