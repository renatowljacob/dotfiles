require("luasnip.session.snippet_collection").clear_snippets("c")

local ls = require("luasnip")
local i = ls.insert_node
local s = ls.snippet
local c = ls.choice_node
local fmta = require("luasnip.extras.fmt").fmta
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("c", {
	s(
		{
			trig = "main",
			docstring = {
				"int main(void)",
				"or",
				"int main(int argc, char *argv[])",
				"{",
				"\t// Function body",
				"\treturn 0;",
				"}",
			},
		},
		c(1, {
			fmta(
				[[
int main(void)
{
	<>

	return 0;
}
]],
				{ i(1, "// Function body") }
			),
			fmta(
				[[
int main(int argc, char *argv[])
{
	<>

	return 0;
}
]],
				{ i(1, "// Function body") }
			),
		})
	),

	s(
		"function",
		fmta(
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
				i(4, "// Function body"),
			}
		)
	),

	s(
		{
			trig = "include",
			docstring = {
				'#include <file.h>/"file.h"',
			},
		},
		c(1, {
			fmt(
				[[
#include <{}>
]],
				{ i(1) }
			),

			fmt(
				[[
#include "{}"
]],
				{ i(1) }
			),
		})
	),

	s(
		{
			trig = "struct",
			docstring = {
				"struct object {",
				"int data;",
				"...",
				"};",
				"_________________________",
				"typedef struct object {",
				"int data;",
				"...",
				"} objects;",
			},
		},
		c(1, {
			fmta(
				[[
struct <> {
	<>
};
]],
				{ i(1, "object"), i(2, "// Struct body") }
			),

			fmta(
				[[
typedef struct <> {
	<>
} <>;
]],
				{ i(1, "object"), i(2, "// Struct body"), i(3, "objects") }
			),
		})
	),
})
