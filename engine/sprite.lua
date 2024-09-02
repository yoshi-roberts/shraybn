---@class Sprite: Entity
---@field super Entity
Sprite = Entity:extend()

---@param path string
function Sprite:new(name, path)
	Sprite.super.new(self --[[@as Entity]], name)

	self.path = path
	-- if asset then
	-- 	self.asset = Assets:get("image", asset)
	-- else
	-- 	self.asset = nil
	-- end
end

---@param position Vec2
---@param scale Vec2
function Sprite:draw(position, scale)
	love.graphics.setColor(1, 1, 1, 1)

	if not scale then
		scale = Vec2(1, 1)
	end

	local asset = Assets:get("image", self.path)
	love.graphics.draw(asset.resource, position:unpack(), scale:unpack())
end

function Sprite:__tostring()
	return "Sprite"
end
