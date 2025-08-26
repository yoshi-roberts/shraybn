local Class = require("libs.class")

---@class editor.CharacterData
local CharacterData = Class:extend()

---@param character engine.Character
---@param path string
function CharacterData:init(character, path)
	self.character = character
	self.path = path
	self.saved = true
end

---@param mood string
---@param asset_path string
function CharacterData:add_portrait(mood, asset_path)
	self.character:add_portrait(mood, asset_path)
end

return CharacterData
