local utils = require("shrift.tests.utils") --[[@as test_utils]]
local lust = require("libs.lust")
local it, expect = lust.it, lust.expect

it("Eval Integer Expression", function()
	local tests = {
		{ "5", 5 },
		{ "10", 10 },
		{ "-5", -5 },
		{ "-10", -10 },
		{ "5 + 5 + 5 + 5 - 10", 10 },
		{ "2 * 2 * 2 * 2 * 2", 32 },
		{ "-50 + 100 + -50", 0 },
		{ "5 * 2 + 10", 20 },
		{ "5 + 2 * 10", 25 },
		{ "20 + 2 * -10", 0 },
		{ "50 / 2 * 2 + 10", 60 },
		{ "2 * (5 + 10)", 30 },
		{ "3 * 3 * 3 + 10", 37 },
		{ "3 * (3 * 3) + 10", 37 },
		{ "(5 + 10 * 2 + 15 / 3) * 2 + -10", 50 },
	}

	for _, v in pairs(tests) do
		local input = v[1]
		local expected = v[2]

		local evaluated = utils.test_eval(input)
		utils.test_integer_object(evaluated, expected)
	end
end)
