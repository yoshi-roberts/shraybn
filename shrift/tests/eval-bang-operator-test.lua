local utils = require("shrift.tests.utils") --[[@as test_utils]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

it("Eval Bang Operator", function()
	local tests = {
		{ "!true", false },
		{ "!false", true },
		{ "!5", false },
		{ "!!true", true },
		{ "!!false", false },
		{ "!!5", true },
	}

	for _, v in pairs(tests) do
		local input = v[1]
		local expected = v[2]

		local evaluated = utils.test_eval(input)
		utils.test_boolean_object(evaluated, expected)
	end
end)
