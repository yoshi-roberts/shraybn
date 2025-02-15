local Sprite = require("engine.sprite")
local Trigger = require("engine.trigger")
local ChangeField = require("editor.command.change_field")

local ChangeScene = require("engine.actions.change_scene")

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

	temp_int = ffi.new("int[1]", 0),
	temp_float = ffi.new("float[1]", 0),
	check_bool = ffi.new("bool[1]", 0),
	current_combo_item = nil,

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
---@param is_int boolean?
function inspector.property_number(target, field, label, is_int)
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

	if is_int then
		inspector.temp_int[0] = target[field]
		if imgui.DragInt("##" .. id .. "_input", inspector.temp_int) then
			editor.history:add(ChangeField:new(target, field, inspector.temp_int[0], true))
		end

		return
	end

	inspector.temp_float[0] = target[field]
	if imgui.DragFloat("##" .. id .. "_input", inspector.temp_float, 0.01) then
		editor.history:add(ChangeField:new(target, field, inspector.temp_float[0], true))
	end
end

---@param target table
---@param field string
---@param label string?
function inspector.resource(target, field, label)
	local text = target[field] or "No Resource"

	if label then
		text = label .. ": " .. text
	end

	imgui.Text(text)

	if imgui.BeginDragDropTarget() then
		imgui.AcceptDragDropPayload("DRAG_DROP_FILE")

		if imgui.IsMouseReleased_Nil(0) and inspector.payload then
			editor.history:add(ChangeField:new(target, field, inspector.payload.asset_name))

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
	imgui.Separator()
end

function inspector.trigger()
	local trigger = inspector.item
	---@cast trigger engine.Trigger

	---@type {[string]: engine.Action}
	local action_types = {
		["Change Scene"] = ChangeScene,
		-- ["Dialogue"],
	}

	if imgui.BeginCombo("Trigger Action", inspector.current_combo_item) then
		for k, action in pairs(action_types) do
			---@cast action engine.Action
			local is_selected = (inspector.current_combo_item == k)

			if imgui.Selectable_Bool(k, is_selected) then
				inspector.current_combo_item = k
				trigger.action = action:new()
			end

			if is_selected then
				imgui.SetItemDefaultFocus()
			end
		end

		imgui.EndCombo()
	end

	if trigger.action and trigger.action:is(ChangeScene) then
		inspector.resource(trigger.action, "scene_name")
	end

	imgui.Separator()
end

function inspector.entity()
	local entity = inspector.item
	---@cast entity engine.Entity

	imgui.Text("Entity: " .. entity.name)
	imgui.Separator()

	if entity:is(Sprite) then
		inspector.sprite()
	elseif entity:is(Trigger) then
		inspector.trigger()
	end

	inspector.property_number(entity.position, "x", "X", true)
	inspector.property_number(entity.position, "y", "Y", true)

	imgui.Separator()

	inspector.property_number(entity.scale, "x", "Scale X")
	inspector.property_number(entity.scale, "y", "Scale Y")

	imgui.Separator()

	inspector.property_number(entity, "rotation", "Rotation")
end

function inspector.layer()
	local layer = inspector.item
	---@cast layer engine.Layer

	imgui.Text("Layer: " .. layer.name)
	imgui.Separator()

	layer.is_active = inspector.bool("Active", layer.is_active)
end

function inspector.project()
	local project = inspector.item
	---@cast project engine.Project

	imgui.Text(project.name)
	imgui.Separator()

	inspector.property_number(project, "window_width", "Window Width", true)
	inspector.property_number(project, "window_height", "Window Height", true)

	imgui.Separator()

	inspector.property_number(project, "game_width", "Game Width", true)
	inspector.property_number(project, "game_height", "Game Height", true)

	imgui.Separator()

	inspector.resource(project, "main_scene", "Main Scene")
end

return inspector
