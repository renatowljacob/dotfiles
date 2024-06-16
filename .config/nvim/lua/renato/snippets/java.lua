require("luasnip.session.snippet_collection").clear_snippets("java")

local ls = require("luasnip")
local c = ls.choice_node
local f = ls.function_node
local i = ls.insert_node
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmta

ls.add_snippets("java", {
	s(
		{
			trig = "Main",
			docstring = {
				"Main class and method",
				"public class Main {",
				"\tpublic static void main(String[] args) {",
				"\t // Method body",
				"\t}",
				"}",
			},
		},
		fmt(
			[[
public class Main {
	public static void main(String[] args) {
		<>
	}
}
]],
			{
				i(1, "// Method body"),
			}
		)
	),
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
	s(
		{
			trig = "print",
			docstring = {
				'System.out.print("");',
				"System.out.print();",
				'System.out.printf("format", args);',
			},
		},
		c(1, {
			fmt('System.out.print("<>");', {
				i(1, "string"),
			}),
			fmt("System.out.print(<>);", {
				i(1, "object"),
			}),
			fmt('System.out.printf("<>", <>);', {
				i(1, "format"),
				i(2, "args"),
			}),
		})
	),
})
