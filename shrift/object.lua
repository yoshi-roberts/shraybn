local Object = require("libs.classic")

---@class object
local object = {}

---@enum ObjectTypes
object.TYPE = {
	INTEGER = "INTEGER",
	BOOLEAN = "BOOLEAN",
	NULL = "NULL",
}

---@alias ObjectType string
---@class ObjectInterface: Object
---@field type fun(self: ObjectInterface): ObjectType
---@field inspect fun(self: ObjectInterface): string

---@class IntegerObject: ObjectInterface
---@field value integer
object.Integer = Object:extend()

---@private
---@param value integer
function object.Integer:new(value)
	self.value = value
end

function object.Integer:type()
	return object.TYPE.INTEGER
end

function object.Integer:inspect()
	return tostring(self.value)
end

---@class BooleanObject: ObjectInterface
---@field value boolean
object.Boolean = Object:extend()

---@private
---@param value boolean
function object.Boolean:new(value)
	self.value = value
end

function object.Boolean:type()
	return object.TYPE.BOOLEAN
end

function object.Boolean:inspect()
	return tostring(self.value)
end

---@class NullObject: ObjectInterface
object.Null = Object:extend()

---@return ObjectType
function object.Null:type()
	return object.TYPE.NULL
end

function object.Null:inspect()
	return "null"
end

return object
