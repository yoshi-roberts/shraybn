---@class Sprite: Entity
---@field super Entity
Sprite = Entity:extend()

---@param path string
function Sprite:new(name, path)
	Sprite.super.new(self --[[@as Entity]], name)

	self.asset_path = path
	-- if asset then
	-- 	self.asset = Assets:get("image", asset)
	-- else
	-- 	self.asset = nil
	-- end
end

---@param position Vec2?
---@param scale Vec2?
function Sprite:draw(position, scale)
	love.graphics.setColor(1, 1, 1, 1)

	local asset = Assets:get("image", self.asset_path)
	love.graphics.draw(asset.resource, self.position.x, self.position.y, self.rotation, self.scale.x, self.scale.y)
end

function Sprite:__tostring()
	return "Sprite"
end
