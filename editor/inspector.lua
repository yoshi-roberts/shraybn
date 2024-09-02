local ffi = require("ffi")

Inspector = {

	item = nil, -- The "item" we are inspecting.
	type = nil,

	viewer_width = 256,
	viewer_height = 384,
	viewer_image = nil,

	vec_x = ffi.new("int[1]", 0),
	vec_y = ffi.new("int[1]", 0),
	check_bool = ffi.new("bool[1]", 0),

	viewer_canvas = love.graphics.newCanvas(256, 384),
	bk_grid = love.graphics.newImage("editor/resources/bk_grid.png"),

	display = require("editor.ui.inspector"),
}

---@param type string | "entity" | "image" | "layer"
---@param item any
function Inspector:inspect(type, item)
	self.item = item
	self.type = type
end

---@param label string
---@param target Vec2
function Inspector:vec2(label, target)
	self.vec_x[0] = target.x
	self.vec_y[0] = target.y

	Imgui.Text(label .. ":")

	Imgui.PushItemWidth(80)

	Imgui.DragInt("X##" .. label .. "_VEC_X", self.vec_x)
	if Imgui.IsItemActive() then
		Editor.history:add(ChangeField(target, "x", self.vec_x[0]), true)
	end

	Imgui.DragInt("Y##" .. label .. "_VEC_Y", self.vec_y)
	if Imgui.IsItemActive() then
		Editor.history:add(ChangeField(target, "y", self.vec_y[0]), true)
	end

	Imgui.PopItemWidth()

	Editor.scenes.current.saved = false
end

function Inspector:bool(label, target)
	self.check_bool[0] = target

	local tag = label .. "##" .. label .. "_CHECKBOX_BOOL"

	if Imgui.Checkbox(tag, self.check_bool) then
		Editor.scenes.current.saved = false
		return self.check_bool[0]
	end

	return target
end

function Inspector:resource(target, field)
	local text = target[field] or "No Resource"
	Imgui.Text(text)

	if Imgui.BeginDragDropTarget() then
		Imgui.AcceptDragDropPayload("DRAG_DROP_FILE")

		if Imgui.IsMouseReleased_Nil(0) and Editor.drag_payload then
			local key = Util.path_to_key(Editor.drag_payload)

			Editor.history:add(ChangeField(target, field, key))

			Editor.drag_payload = nil
			Editor.scenes.current.saved = false
		end

		Imgui.EndDragDropTarget()
	end
end

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

function Inspector:sprite()
	local sprite = self.item

	if sprite.path then
		self:image(Assets:get("image", sprite.path))
	end

	self:resource(sprite, "path")
end

function Inspector:entity()
	local entity = self.item

	Imgui.Text("Entity: " .. entity.name)
	Imgui.Separator()

	if entity:is(Sprite) then
		self:sprite()
	end

	self:vec2("Position", entity.position)
	self:vec2("Scale", entity.scale)
end

function Inspector:layer()
	local layer = self.item

	Imgui.Text("Layer: " .. layer.name)
	Imgui.Separator()

	layer.active = self:bool("Active", layer.active)
end
