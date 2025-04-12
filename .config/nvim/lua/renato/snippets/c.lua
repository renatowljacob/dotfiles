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
            name = "docstring",
            trig = "docstring",
            docstring = {
                "/**",
                "* docstring body",
                "*/",
            },
        },
        fmta(
            [[
/**
 * <>
 */
]],
            { i(1, "docstring") }
        )
    ),
    s(
        {
            name = "main function",
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
            name = "source file inclusion",
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

    s(
        {
            name = "for loop",
            trig = "for",
            docstring = {
                "for (init-statement; condition; inc-expression) {",
                "\t// Loop body",
                "}",
            },
        },
        c(1, {
            fmta(
                [[
for (<>; <>; <>) {
	<>
}
]],
                {
                    i(1, "init-statement"),
                    i(2, "condition"),
                    i(3, "inc-expression"),
                    i(4, "// Loop body"),
                }
            ),

            fmta(
                [[
for (<>; <>; <>)
{
	<>
}
]],
                {
                    i(1, "init-statement"),
                    i(2, "condition"),
                    i(3, "inc-expression"),
                    i(4, "// Loop body"),
                }
            ),
        })
    ),

    s(
        {
            name = "while loop",
            trig = "while",
            docstring = {
                "while (expression) {",
                "\t// Loop body",
                "}",
            },
        },
        c(1, {
            fmta(
                [[
while (<>) {
	<>
}
]],
                { i(1, "expression"), i(2, "// While body") }
            ),

            fmta(
                [[
while (<>)
{
	<>
}
]],
                { i(1, "expression"), i(2, "// While body") }
            ),
        })
    ),

    s(
        {
            name = "do while loop",
            trig = "do .. while",
            docstring = {
                "do {",
                "\t// Loop body",
                "} while (expression)",
            },
        },
        c(1, {
            fmta(
                [[
do {
	<>
} while (<>);
]],
                { i(1, "// While body"), i(2, "expression") }
            ),

            fmta(
                [[
do
{
	<>
}
while (<>);
]],
                { i(1, "// While body"), i(2, "expression") }
            ),
        })
    ),

    s(
        {
            name = "if condition",
            trig = "if",
            docstring = {
                "if (expression) {",
                "\t// If body",
                "}",
            },
        },
        c(1, {
            fmta(
                [[
if (<>) {
	<>
}
]],
                { i(1, "expression"), i(2, "// Body") }
            ),

            fmta(
                [[
if (<>)
{
	<>
}
]],
                { i(1, "expression"), i(2, "// Body") }
            ),
        })
    ),

    s(
        {
            name = "else condition",
            trig = "else",
            docstring = {
                "else (expression) {",
                "\t// Else body",
                "}",
            },
        },
        c(1, {
            fmta(
                [[
else {
	<>
}
]],
                { i(1, "// Body") }
            ),

            fmta(
                [[
else
{
	<>
}
]],
                { i(1, "// Body") }
            ),
        })
    ),

    s(
        {
            name = "else if condition",
            trig = "else if",
            docstring = {
                "else if (expression) {",
                "\t// Else If body",
                "}",
            },
        },
        c(1, {
            fmta(
                [[
else if (<>) {
	<>
}
]],
                { i(1, "expression"), i(2, "// Body") }
            ),

            fmta(
                [[
else if (<>)
{
	<>
}
]],
                { i(1, "expression"), i(2, "// Body") }
            ),
        })
    ),
})
