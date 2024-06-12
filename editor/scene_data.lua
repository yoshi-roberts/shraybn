SceneData = {}

function SceneData.new(name)
	Nativefs.setWorkingDirectory(Editor.loaded_project.name)
	local exists = Nativefs.getInfo("scenes/" .. name .. ".scd")

	if exists ~= nil then
		return false
	end

	local scene = {
		name = name,
		layers = {},
	}

	local serialized = Binser.serialize(scene)
	Nativefs.write("scenes/" .. name .. ".scd", serialized, #serialized)

	Nativefs.setWorkingDirectory("..")

	return true, scene
end

function SceneData.load(file)
	local contents = Nativefs.read(file)
	local deserialized = Binser.deserialize(contents)
	return deserialized[1]
end

return SceneData
