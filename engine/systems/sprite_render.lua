local sprite_render = System({ pool = { "transform", "image" } })

function sprite_render:draw()
	for _, e in ipairs(self.pool) do
		love.graphics.setColor(1, 0, 0, 1)
		local pos = e.transform.position
		local rot = e.transform.rotation
		love.graphics.circle("fill", pos.x, pos.y, 32)
		love.graphics.setColor(1, 1, 1, 1)
	end
end

return sprite_render
