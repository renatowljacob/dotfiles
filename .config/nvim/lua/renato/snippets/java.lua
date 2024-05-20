require("luasnip.session.snippet_collection").clear_snippets("java")

local ls = require("luasnip")
local f = ls.function_node
local i = ls.insert_node
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmta

-- fmt( ({}), nodes)
ls.add_snippets("java", {
	s(
		"getter",
		fmt(
			[[
<> get<>() {
	return <>;
}
]],
			{
				i(1, "type"),
				f(function(attribute)
					local method = string.sub(string.upper(attribute[1][1]), 1, 1)
						.. string.sub(string.lower(attribute[1][1]), 2, -1)
					return method or ""
				end, { 2 }),
				i(2, "attribute"),
			}
		)
	),
	s(
		"setter",
		fmt(
			[[
void set<>(<> <attribute>) {
	this.<attribute> = <attribute>;
}
]],
			{
				f(function(attribute)
					local method = string.sub(string.upper(attribute[1][1]), 1, 1)
						.. string.sub(string.lower(attribute[1][1]), 2, -1)
					return method or ""
				end, { 2 }),
				i(1, "type"),
				attribute = i(2, "attribute"),
			},
			{
				repeat_duplicates = true,
			}
		)
	),
})
