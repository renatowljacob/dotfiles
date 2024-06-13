require("luasnip.session.snippet_collection").clear_snippets("c")

local ls = require("luasnip")
local i = ls.insert_node
local s = ls.snippet
local fmta = require("luasnip.extras.fmt").fmta
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("c", {
	s(
		{
			trig = "main",
			docstring = {
				"Void main function",
				"int main(void)",
				"{",
				"\t// Function body",
				"\treturn 0;",
				"}",
			},
		},
		fmta(
			[[
int main(void)
{
	<>

	return 0;
}
]],
			{ i(1, "// Function body") }
		)
	),
	s(
		{
			trig = "main(argc, argv)",
			docstring = {
				"Main function with command-line arguments",
				"int main(int argc, char **argv)",
				"{",
				"\t// Function body",
				"\treturn 0;",
				"}",
			},
		},
		fmta(
			[[
int main(int argc, char **argv)
{
	<>

	return 0;
}
]],
			{ i(1, "// Function body") }
		)
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
			trig = "include_sys",
			docstring = {
				"System header file",
				"#include <file.h>",
			},
		},
		fmt(
			[[
#include <{}>
]],
			{ i(1) }
		)
	),
	s(
		{
			trig = "include_loc",
			docstring = {
				"Local header/source file",
				'#include "file.h"',
			},
		},
		fmt(
			[[
#include "{}"
]],
			{ i(1) }
		)
	),
})
