---@class SceneData
SceneData = {}

---@alias scene_data {unsaved: boolean, name: string, layers: table}

---@param name string
---@return boolean
---@return scene_data?
---
function SceneData.new(name)
	Nativefs.setWorkingDirectory(Editor.loaded_project.name)
	local exists = Nativefs.getInfo("scenes/" .. name .. ".scd")

	-- Check if scene already exists.
	if exists ~= nil then
		return false, nil
	end

	---@type scene_data
	local scene = {
		unsaved = false,
		name = name,
		layers = {},
	}

	-- Serialize scene data and write to file.
	local serialized = Binser.serialize(scene)
	Nativefs.write("scenes/" .. name .. ".scd", serialized, #serialized)

	-- Set working directory back to projects/
	Nativefs.setWorkingDirectory("..")

	return true, scene
end

---@param file string
---@return scene_data
function SceneData.load(file)
	local contents = Nativefs.read(file)
	local deserialized = Binser.deserialize(contents)

	-- for _, layer in pairs(deserialized[1]) do
	-- 	if layer.type == "image" then
	-- 		print(layer.image)
	-- 	end
	-- end

	return deserialized[1]
end

---@param scene scene_data
---@param type string
---| "image"
---| "trigger"
function SceneData.new_layer(scene, type)
	local name = "Layer" .. (#scene.layers + 1)
	table.insert(scene.layers, {
		name = name,
		type = type,
		visible = true,
	})

	scene.unsaved = true
end

function SceneData.remove_layer(scene, index)
	table.remove(scene.layers, index)
	scene.unsaved = true
end

---@param scene scene_data
function SceneData.save(scene)
	Nativefs.setWorkingDirectory(Editor.loaded_project.name)

	scene.unsaved = false
	local serialized = Binser.serialize(scene)
	Nativefs.write("scenes/" .. scene.name .. ".scd", serialized, #serialized)

	Nativefs.setWorkingDirectory("..")
end

return SceneData
