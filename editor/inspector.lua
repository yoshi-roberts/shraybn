local Sprite = require("engine.sprite")
local ChangeField = require("editor.command.change_field")
local editor = require("editor")
local assets = require("engine.assets")
local imgui = require("engine.imgui")
local ffi = require("ffi")

---@class editor.inspector
local inspector = {

	-- item = nil, -- The "item" we are inspecting.
	type = nil,

	viewer_width = 256,
	viewer_height = 384,
	viewer_image = nil,

	temp_num = ffi.new("int[1]", 0),
	check_bool = ffi.new("bool[1]", 0),

	viewer_canvas = love.graphics.newCanvas(256, 384),
	bk_grid = love.graphics.newImage("editor/resources/bk_grid.png"),

	display = require("editor.ui.inspector"),
}

---@param type string
---| "image"
---| "entity"
---| "layer"
---| "project"
---@param item any
function inspector.inspect(type, item)
	inspector.item = item
	inspector.type = type
end

function inspector.bool(label, target)
	inspector.check_bool[0] = target

	local tag = label .. "##" .. label .. "_CHECKBOX_BOOL"

	if imgui.Checkbox(tag, inspector.check_bool) then
		editor.scenes.current.saved = false
		return inspector.check_bool[0]
	end

	return target
end

---@param target table
---@param field string
---@param label string
function inspector.property_int(target, field, label)
	inspector.temp_num[0] = target[field]
	local id = string.format("%p", target) .. "_" .. field

	local total_width = imgui.GetContentRegionAvail().x
	local height = imgui.GetTextLineHeightWithSpacing()
	local pos = imgui.ImVec2_Float(total_width * 0.5, height)

	imgui.SetNextItemWidth(total_width * 0.5)
	imgui.BeginChild_Str(id .. "_text_child", pos, false)
	imgui.Text(label)
	imgui.EndChild()

	imgui.SameLine()

	local available_width = imgui.GetContentRegionAvail().x
	imgui.SetNextItemWidth(available_width)

	imgui.DragInt("##" .. id .. "_input", inspector.temp_num)
	if imgui.IsItemActive() then
		editor.history:add(ChangeField:new(target, field, inspector.temp_num[0]), false)
	end
end

function inspector.resource(target, field)
	local text = target[field] or "No Resource"
	imgui.Text(text)

	if imgui.BeginDragDropTarget() then
		imgui.AcceptDragDropPayload("DRAG_DROP_FILE")

		if imgui.IsMouseReleased_Nil(0) and editor.drag_payload then
			-- editor.history:add(ChangeField:new(target, field, editor.drag_payload))

			editor.drag_payload = nil
			editor.scenes.current.saved = false
		end

		imgui.EndDragDropTarget()
	end
end

function inspector.image(image)
	local win_width = imgui.GetContentRegionAvail().x

	-- TODO: Find a better way to do this.
	-- Resize the canvas if needed.
	if inspector.viewer_width ~= win_width then
		inspector.viewer_width = win_width
		if inspector.viewer_width > 0 and inspector.viewer_height > 0 then
			inspector.viewer_canvas =
				love.graphics.newCanvas(inspector.viewer_width, inspector.viewer_height)
		end
	end

	love.graphics.setCanvas(inspector.viewer_canvas)

	local tile_size = 32
	local x_tiles = math.ceil(inspector.viewer_width / tile_size)
	local y_tiles = math.ceil(inspector.viewer_height / tile_size)

	-- Draw grid to canvas.
	for x = 1, x_tiles, 1 do
		for y = 1, y_tiles, 1 do
			local pos_x = (x - 1) * tile_size
			local pos_y = (y - 1) * tile_size

			love.graphics.draw(inspector.bk_grid, pos_x, pos_y)
		end
	end

	if image then
		local res = image.resource

		local scale_x = inspector.viewer_canvas:getWidth() / res:getWidth()
		local scale_y = inspector.viewer_canvas:getHeight() / res:getHeight()
		local scale = math.min(scale_x, scale_y)

		local width = res:getWidth() * scale
		local height = res:getHeight() * scale
		local x = (inspector.viewer_canvas:getWidth() / 2) - (width / 2)
		local y = (inspector.viewer_canvas:getHeight() / 2) - (height / 2)

		love.graphics.draw(res, x, y, 0, scale)
	end

	love.graphics.setCanvas()

	local size = imgui.ImVec2_Float(inspector.viewer_canvas:getDimensions())
	imgui.Image(inspector.viewer_canvas, size)
end

function inspector.sprite()
	local sprite = inspector.item

	if sprite.asset_path then
		inspector.image(assets.get(sprite.asset_path))
	end

	inspector.resource(sprite, "asset_path")
end

function inspector.entity()
	local entity = inspector.item
	---@cast entity engine.Entity

	imgui.Text("Entity: " .. entity.name)
	imgui.Separator()

	if entity:is(Sprite) then
		inspector:sprite()
	end

	inspector.property_int(entity.position, "x", "X")
	inspector.property_int(entity.position, "y", "Y")
end

function inspector.layer()
	local layer = inspector.item
	---@cast layer engine.Layer

	imgui.Text("Layer: " .. layer.name)
	imgui.Separator()

	layer.active = inspector.bool("Active", layer.active)
end

function inspector.project()
	local project = inspector.item
	---@cast project engine.Project

	imgui.Text(project.name)
	imgui.Separator()

	inspector.property_int(project, "window_width", "Window Width")
	inspector.property_int(project, "window_height", "Window Height")
	imgui.Separator()
end

return inspector
