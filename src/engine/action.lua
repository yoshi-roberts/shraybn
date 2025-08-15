local Class = require("libs.class")
local log = require("libs.log")

---@class engine.Action: Class
local Action = Class:extend()

function Action:init() end

function Action:execute()
	log.info("[ACTION] Executing '" .. tostring(self) .. "'")
end

function Action:undo() end

return Action
