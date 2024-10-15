local Object = require("libs.classic")

---@class object
local object = {}

---@enum ObjectTypes
local TYPE = {
	INTEGER_OBJ = "INTEGER",
	BOOLEAN_OBJ = "BOOLEAN",
	NULL_OBJ = "NULL",
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
	return TYPE.INTEGER_OBJ
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
	return TYPE.BOOLEAN_OBJ
end

function object.Boolean:inspect()
	return tostring(self.value)
end

---@class NullObject
object.Null = Object:extend()

---@return ObjectType
function object.Null:type()
	return TYPE.NULL_OBJ
end

function object.Null:inspect()
	return "null"
end

return object
