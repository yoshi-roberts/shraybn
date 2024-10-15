local utils = require("shrift.tests.utils") --[[@as test_utils]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

it("Eval Boolean Expression", function()
	local tests = {
		{ "true", true },
		{ "false", false },
		{ "1 < 2", true },
		{ "1 > 2", false },
		{ "1 < 1", false },
		{ "1 > 1", false },
		{ "1 == 1", true },
		{ "1 != 1", false },
		{ "1 == 2", false },
		{ "1 != 2", true },
	}

	for _, v in pairs(tests) do
		local input = v[1]
		local expected = v[2]

		local evaluated = utils.test_eval(input)
		utils.test_boolean_object(evaluated, expected)
	end
end)
