local Sprite = require("engine.sprite")
local Trigger = require("engine.trigger")
local Character = require("engine.character")
local ChangeField = require("editor.command.change_field")

local ChangeSceneAction = require("engine.actions.change_scene")
local Dialogue = require("engine.actions.dialogue")

local editor = require("editor")
local assets = require("engine.assets")
local nativefs = require("libs.nativefs")
local binser = require("libs.binser")
local log = require("libs.log")
local signal = require("engine.signal")
local imgui = require("engine.imgui")
local widgets = require("editor.widgets")
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

---@param type string
---| "image"
---| "entity"
---| "layer"
---| "characters"
---| "project"
---@param item any
function inspector.inspect(type, item)
	inspector.item = item
	inspector.type = type
end

function inspector.sprite()
	local sprite = inspector.item
	---@cast sprite engine.Sprite

	if sprite.asset_path then
		widgets.image(assets.get(sprite.asset_path), inspector.viewer_height)
	end

	widgets.resource(sprite, "asset_path", nil, editor.scenes.current)
	imgui.Separator()
end

function inspector.trigger()
	local trigger = inspector.item
	---@cast trigger engine.Trigger

	---@type {[string]: engine.Action}
	local action_types = {
		["ChangeSceneAction"] = ChangeSceneAction,
		["DialogueAction"] = Dialogue,
	}

	local current = tostring(trigger.action)

	if trigger.action and not inspector.current_combo_item then
		inspector.current_combo_item = current
	end

	if imgui.BeginCombo("Trigger Action", inspector.current_combo_item) then
		for k, action in pairs(action_types) do
			---@cast action engine.Action

			local is_selected = (inspector.current_combo_item == k)

			if imgui.Selectable_Bool(k, is_selected) and current ~= k then
				inspector.current_combo_item = k
				trigger.action = action:new()
			end

			if is_selected then
				imgui.SetItemDefaultFocus()
			end
		end

		imgui.EndCombo()
	end

	if trigger.action and trigger.action:is(ChangeSceneAction) then
		widgets.resource(trigger.action, "scene_path", editor.scenes.current)
	end

	if trigger.action and trigger.action:is(Dialogue) then
		widgets.resource(trigger.action, "script_path", editor.scenes.current)
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

	widgets.property_number(entity.position, "x", "X", true, editor.scenes.current)
	widgets.property_number(entity.position, "y", "Y", true, editor.scenes.current)

	imgui.Separator()

	widgets.property_number(entity.scale, "x", "Scale X", false, editor.scenes.current)
	widgets.property_number(entity.scale, "y", "Scale Y", false, editor.scenes.current)

	imgui.Separator()

	widgets.property_number(entity, "rotation", "Rotation", false, editor.scenes.current)
end

function inspector.layer()
	local layer = inspector.item
	---@cast layer engine.Layer

	imgui.Text("Layer: " .. layer.name)
	imgui.Separator()

	-- layer.is_active = inspector.bool("Active", layer.is_active)
end

function inspector.project()
	local project = inspector.item
	---@cast project engine.Project

	imgui.Text(project.name)
	imgui.Separator()

	widgets.property_number(project, "window_width", "Window Width", true)
	widgets.property_number(project, "window_height", "Window Height", true)

	imgui.Separator()

	widgets.property_number(project, "game_width", "Game Width", true)
	widgets.property_number(project, "game_height", "Game Height", true)

	imgui.Separator()

	widgets.resource(project, "main_scene", "Main Scene")
end

function inspector.asset_image()
	local asset = inspector.item[1]
	local resource_data = inspector.item[2]

	imgui.Text(asset.path)

	if imgui.Button("Reimport") then
		local serialized = binser.serialize(assets.resource_data[asset.path])

		local res_path = asset.path .. ".srd"

		if not nativefs.write(res_path, serialized, #serialized) then
			log.error("[EDITOR] Failed to reimport resource '" .. res_path .. "'")
		else
			log.info("[EDITOR] Reimported resource '" .. res_path .. "'")
		end

		assets.import(asset.path)
	end

	widgets.image(asset, inspector.viewer_height)

	local filters = {
		["linear"] = "linear",
		["nearest"] = "nearest",
	}
	widgets.combo(resource_data, "filter", filters, "Filter")
end

return inspector
