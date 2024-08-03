---@class SceneData
SceneData = Object:extend()

---@param data Scene
---@param path string
function SceneData:new(data, path)
	self.data = data
	self.path = path
	self.saved = true
	self.entity_count = data:entity_type_count()
	self.last_deleted = {
		name = nil,
		type = nil,
	}
end
