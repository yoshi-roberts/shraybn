local binser = require("libs.binser")

-- Slightly modified version of classic by rxi
-- Works better with the lua-language-server type system.

---@class Class
---@field init function
---@field super Class
Class = {}
---@private
Class.__index = Class

---@return Class
function Class:extend()
	local cls = {}
	for k, v in pairs(self) do
		if k:find("__") == 1 then
			cls[k] = v
		end
	end
	cls.__index = cls
	cls.super = self
	setmetatable(cls, self)
	return cls
end

---@return boolean
function Class:is(T)
	local mt = getmetatable(self)
	while mt do
		if mt == T then
			return true
		end
		mt = getmetatable(mt)
	end
	return false
end

---@private
---@return string
function Class:__tostring()
	return "Object"
end

---@generic T : Class
---@param self T
---@return T
function Class:new(...)
	local instance = setmetatable({}, self)
	instance:init(...)
	return instance
end

binser.register(Class, "Class")
return Class
