local Class = require("libs.class")

---@class editor.SceneData : Class
local SceneData = Class:extend()

local function contains(table, value)
	for _, v in pairs(table) do
		if v == value then
			return true
		end
	end
	return false
end

---@param data engine.Scene
---@param path string
function SceneData:init(data, path)
	self.data = data
	self.path = path
	self.saved = true
	self.entity_count = data:entity_count()
	self.available_names = {}
end

---@param list table
---@param name string
function SceneData:remove_name(list, name)
	for k, v in pairs(list) do
		if v == name then
			return table.remove(list, k)
		end
	end
end

function SceneData:sort_available_names()
	local sort = function(a, b)
		return tonumber(a:match("%d+")) < tonumber(b:match("%d+"))
	end

	for _, types in pairs(self.available_names) do
		for _, names in pairs(types) do
			table.sort(names, sort)
		end
	end
end

function SceneData:get_available_names()
	local indicies = {}

	for _, entity in pairs(self.data.entities) do
		local layer = entity.layer.name
		local type = tostring(entity)

		indicies[layer] = indicies[layer] or {}
		indicies[layer][type] = indicies[layer][type] or {}

		local index = entity.name:sub(#entity.name, #entity.name)
		index = tonumber(index)
		if index then
			table.insert(indicies[layer][type], index)
		end
	end

	local function sort(a, b)
		return a < b
	end

	for layer, types in pairs(indicies) do
		for type, names in pairs(types) do
			table.sort(names, sort)

			local max = names[#names]

			for i = 1, max, 1 do
				if not contains(names, i) then
					self.available_names[layer] = self.available_names[layer] or {}
					self.available_names[layer][type] = self.available_names[layer][type] or {}

					table.insert(self.available_names[layer][type], type .. i)
				end
			end
		end
	end
end

return SceneData
