---@class shrift.evaluator
local evaluator = {}

---@param line shrift.LineData
---@param env table
---@return any
function evaluator.evaluate_value(line, env)
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

return evaluator
