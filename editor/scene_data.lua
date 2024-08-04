---@class SceneData
SceneData = Object:extend()

local function contains(table, value)
	for _, v in pairs(table) do
		if v == value then
			return true
		end
	end
	return false
end

function SceneData:init_available_names()
	local available_names = {}
	local max_indicies = {}
	local existing_indicies = {}
	local layer_types = {}

	for _, entity in pairs(self.data.entities) do
		local index = tonumber(entity.name:match("%d+"))
		local layer = entity.layer.name

		if not existing_indicies[layer] then
			existing_indicies[layer] = {}
		end

		if not max_indicies[layer] then
			max_indicies[layer] = 0
		end

		if not layer_types[layer] then
			layer_types[layer] = tostring(entity)
		end

		table.insert(existing_indicies[layer], index)

		if index > max_indicies[layer] then
			max_indicies[layer] = index
		end
	end

	for layer, max_index in pairs(max_indicies) do
		for i = 1, max_index do
			if not contains(existing_indicies[layer], i) then
				if not available_names[layer] then
					available_names[layer] = {}
				end

				local name = layer_types[layer] .. i
				table.insert(available_names[layer], name)
			end
		end
	end

	for _, names in pairs(available_names) do
		table.sort(names, function(a, b)
			return tonumber(a:match("%d+")) < tonumber(b:match("%d+"))
		end)
	end

	return available_names
end

---@param data Scene
---@param path string
function SceneData:new(data, path)
	self.data = data
	self.path = path
	self.saved = true
	self.entity_count = data:entity_count()
	self.available_names = self:init_available_names()
end
