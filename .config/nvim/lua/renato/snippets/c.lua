require("luasnip.session.snippet_collection").clear_snippets("java")

local ls = require("luasnip")
local i = ls.insert_node
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmta

-- fmt( (<>), nodes)
ls.add_snippets("c", {
	s(
		"main",
		fmt(
			[[
int main(void)
{
	<>

	return 0;
}
]],
			{
				i(1, "// function body"),
			}
		)
	),
	s(
		"main(argc, argv)",
		fmt(
			[[
int main(int argc, char **argv)
{
	<>

	return 0;
}
]],
			{
				i(1, "// function body"),
			}
		)
	),
	s(
		"function",
		fmt(
			[[
<> <>(<>)
{
	<>
}
]],
			{
				i(1, "type"),
				i(2, "name"),
				i(3, "parameter"),
				i(4, "// function body"),
			}
		)
	),
})
