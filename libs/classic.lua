--
-- classic
--
-- Copyright (c) 2014, rxi
--
-- This module is free software; you can redistribute it and/or modify it under
-- the terms of the MIT license. See LICENSE for details.
--

---@class Object
local Object = {}
---@private
Object.__index = Object

---@private
function Object:new() end

function Object:extend()
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

function Object:implement(...)
	for _, cls in pairs({ ... }) do
		for k, v in pairs(cls) do
			if self[k] == nil and type(v) == "function" then
				self[k] = v
			end
		end
	end
end

---@return boolean
function Object:is(T)
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
function Object:__tostring()
	return "Object"
end

---@generic T : Object
---@param self T
---@return T
function Object:__call(...)
	local obj = setmetatable({}, self)
	obj:new(...)
	return obj
end

return Object
