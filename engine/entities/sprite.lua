local function sprite(e, image, position, rotation, layer)
	e:give("image", image)
	e:give("transform", position, rotation)
	-- e:give("layer", layer or 0)
end

return sprite
