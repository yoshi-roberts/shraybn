local ffi = require("ffi")

Inspector = {

	item = nil, -- The "item" we are inspecting.
	type = nil,

	viewer_width = 256,
	viewer_height = 384,
	viewer_image = nil,

	entity_pos_x = ffi.new("int[1]", 0),
	entity_pos = ffi.new("int[2]", { 0.0, 0.0 }),
	entity_scale = ffi.new("int[2]", { 0.0, 0.0 }),

	viewer_canvas = love.graphics.newCanvas(256, 384),
	bk_grid = love.graphics.newImage("editor/resources/bk_grid.png"),

	display = require("editor.ui.inspector"),
}

---@param type string | "entity" | "image"
---@param item any
function Inspector:inspect(type, item)
	self.item = item
	self.type = type
end

function Inspector:vec2(vec) end

function Inspector:image(image)
	local win_width = Imgui.GetContentRegionAvail().x

	-- Resize the canvas if needed.
	if self.viewer_width ~= win_width then
		self.viewer_width = win_width
		if self.viewer_width > 0 and self.viewer_height > 0 then
			self.viewer_canvas = love.graphics.newCanvas(self.viewer_width, self.viewer_height)
		end
	end

	love.graphics.setCanvas(self.viewer_canvas)

	local tile_size = 32
	local x_tiles = math.ceil(self.viewer_width / tile_size)
	local y_tiles = math.ceil(self.viewer_height / tile_size)

	-- Draw grid to canvas.
	for x = 1, x_tiles, 1 do
		for y = 1, y_tiles, 1 do
			local pos_x = (x - 1) * tile_size
			local pos_y = (y - 1) * tile_size

			love.graphics.draw(self.bk_grid, pos_x, pos_y)
		end
	end

	if image then
		local res = image.resource

		local scale_x = self.viewer_canvas:getWidth() / res:getWidth()
		local scale_y = self.viewer_canvas:getHeight() / res:getHeight()
		local scale = math.min(scale_x, scale_y)

		local width = res:getWidth() * scale
		local height = res:getHeight() * scale
		local x = (self.viewer_canvas:getWidth() / 2) - (width / 2)
		local y = (self.viewer_canvas:getHeight() / 2) - (height / 2)

		love.graphics.draw(res, x, y, 0, scale)
	end

	love.graphics.setCanvas()

	local size = Imgui.ImVec2_Float(self.viewer_canvas:getDimensions())
	Imgui.Image(self.viewer_canvas, size)
end

function Inspector:entity()
	local entity = self.item

	Imgui.Text("Entity: " .. entity.name)
	Imgui.Separator()

	self.entity_pos[0] = entity.position.x
	self.entity_pos[1] = entity.position.y
	self.entity_scale[0] = entity.scale.x
	self.entity_scale[1] = entity.scale.y

	Imgui.PushItemWidth(80)
	Imgui.DragInt("X", self.entity_pos_x)
	Imgui.SameLine()
	Imgui.DragInt("Y", self.entity_pos_x)
	Imgui.PopItemWidth()

	-- Imgui.Text("Position:")
	-- Imgui.SameLine()
	-- Imgui.DragFloat2("##entity_position", self.entity_pos, 0.1, 0.0, math.huge, "%.2f", 1.0)
	--
	-- if Imgui.IsItemDeactivatedAfterEdit() then
	-- 	print("Changed!")
	-- 	Editor.history:add(ChangeVec2(entity.position, Vec2(self.entity_pos[0], self.entity_pos[1])))
	-- end
	--
	-- Imgui.Text("Scale   :")
	-- Imgui.SameLine()
	-- Imgui.DragFloat2("##entity_scale", self.entity_scale, 0.1, 0.0, math.huge, "%.2f", 1.0)

	-- entity.position.x = self.entity_pos[0]
	-- entity.position.y = self.entity_pos[1]
	-- entity.scale.x = self.entity_scale[0]
	-- entity.scale.y = self.entity_scale[1]
end

function Inspector:layer()
	local layer = self.item

	local first = layer.type:sub(1, 1):upper()
	local last = layer.type:sub(2, #layer.type)
	local str = first .. last
	Imgui.Text(str .. " layer.")

	if layer.type == "image" then
		local image_path = "No Image."
		if layer.image then
			image_path = layer.image
		end
		Imgui.Text(image_path)

		if Imgui.BeginDragDropTarget() then
			Imgui.AcceptDragDropPayload("DRAG_DROP_FILE")
			if Imgui.IsMouseReleased_Nil(0) then
				if Editor.drag_payload then
					local key = Util.path_to_key(Editor.drag_payload)
					Editor:add_entity(Engine.entities.sprite, key)

					Editor.drag_payload = nil
					Editor.current_scene.unsaved = true
				end
			end

			Imgui.EndDragDropTarget()
		end

		local key, asset
		if layer.image then
			key = Util.path_to_key(layer.image)
			asset = Assets:get("image", key)
		end

		self:image(asset)
	end
end
