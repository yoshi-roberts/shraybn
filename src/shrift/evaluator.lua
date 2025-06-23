---@class shrift.evaluator
local evaluator = {}

---@param line shrift.LineData
---@param env table
function evaluator.eval_line(line, env)
	if line.type == "DIALOGUE" or line.type == "CHOICE" then
		return evaluator.eval_condition(line, env)
	elseif line.type == "ASSIGN" then
		return evaluator.eval_value(line, env)
	end
end

---@param line shrift.LineData
---@param env table
---@return any
function evaluator.eval_value(line, env)
	local expression = line.data.value:gsub("%$", "vars.")

	local template = "return " .. expression
	local fn = load(template, nil, nil, env)

	if fn then
		local success, result = pcall(fn)
		env.vars[line.data.name] = result

		if success then
			return result
		end
	end

	return nil
end

---@param line shrift.LineData
---@param env table
---@return boolean
function evaluator.eval_condition(line, env)
	if line.data.condition == nil or line.data.result then
		return true
	end

	local expression = line.data.condition:gsub("%$", "vars.")

	local template = "return " .. expression
	local fn = load(template, nil, nil, env)

	if fn then
		local success, result = pcall(fn)

		if success then
			line.data.result = result
			return result
		end
	end

	return false
end

return evaluator
