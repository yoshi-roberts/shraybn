local Class = require("libs.class")

---@class engine.Action: Class
local Action = Class:extend()

function Action:init() end

function Action:execute() end
function Action:undo() end

return Action
