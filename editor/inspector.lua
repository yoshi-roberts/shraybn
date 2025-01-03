local Sprite = require("engine.sprite")
local ChangeField = require("editor.command.change_field")
local editor = require("editor")
local assets = require("engine.assets")
local signal = require("engine.signal")
local imgui = require("engine.imgui")
local ffi = require("ffi")

---@class editor.inspector
local inspector = {

	item = nil,
	type = nil, ---@type string
	payload = nil, ---@type table

	viewer_width = 256,
	viewer_height = 384,
	viewer_image = nil,

	temp_num = ffi.new("int[1]", 0),
	check_bool = ffi.new("bool[1]", 0),

	bk_grid = love.graphics.newImage("editor/resources/bk_grid.png"),

	display = require("editor.ui.inspector"),
}

signal.register("editor_file_drag", function(payload)
	if not inspector.payload then
		inspector.payload = payload
	end
end)

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

	if imgui.DragInt("##" .. id .. "_input", inspector.temp_num) then
		editor.history:add(ChangeField:new(target, field, inspector.temp_num[0], true))
	end
end

---@param target table
---@param field string
function inspector.resource(target, field)
	local text = target[field] or "No Resource"
	imgui.Text(text)

	if imgui.BeginDragDropTarget() then
		imgui.AcceptDragDropPayload("DRAG_DROP_FILE")

		if imgui.IsMouseReleased_Nil(0) and inspector.payload then
			editor.history:add(ChangeField:new(target, field, inspector.payload.path))

			inspector.payload = nil
		end

		imgui.EndDragDropTarget()
	end
end

function inspector.image(image)
	local win_width = imgui.GetContentRegionAvail().x

	local view_width = win_width
	local view_height = 384

	local tile_size = 32
	local xtiles = math.floor(view_width / tile_size)
	local ytiles = math.floor(view_height / tile_size)

	local child_size = imgui.ImVec2_Float(view_width, view_height)
	local flags = imgui.love.WindowFlags("NoScrollbar", "NoScrollWithMouse")

	imgui.BeginChild_Str("inspector_image_view", child_size, false, flags)

	local startx = imgui.GetCursorPosX()
	local starty = imgui.GetCursorPosY()

	local tex_size = imgui.ImVec2_Float(tile_size, tile_size)

	-- Draw the grid.
	for x = 0, xtiles do
		for y = 0, ytiles do
			local xp = startx + (x * tile_size)
			local yp = starty + (y * tile_size)
			imgui.SetCursorPos(imgui.ImVec2_Float(xp, yp))
			imgui.Image(inspector.bk_grid, tex_size)
		end
	end

	-- Calculate image scaling and position.
	local img_width = image.resource:getWidth()
	local img_height = image.resource:getHeight()
	local sx = view_width / img_width
	local sy = view_height / img_height
	local scale = math.min(sx, sy)
	local image_size = imgui.ImVec2_Float(img_width * scale, img_height * scale)

	local xpos = (startx + (view_width / 2)) - ((img_width * scale) / 2)
	local ypos = (starty + (view_height / 2)) - ((img_height * scale) / 2)

	-- Draw the image.
	imgui.SetCursorPos(imgui.ImVec2_Float(xpos, ypos))
	imgui.Image(image.resource, image_size)

	imgui.EndChild()
end

function inspector.sprite()
	local sprite = inspector.item
	---@cast sprite engine.Sprite

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
