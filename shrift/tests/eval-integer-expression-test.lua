local utils = require("shrift.tests.utils") --[[@as test_utils]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

it("Eval Integer Expression", function()
	local tests = {
		{ "5", 5 },
		{ "10", 10 },
		{ "-5", -5 },
		{ "-10", -10 },
	}

	for _, v in pairs(tests) do
		local input = v[1]
		local expected = v[2]

		local evaluated = utils.test_eval(input)
		utils.test_integer_object(evaluated, expected)
	end
end)
