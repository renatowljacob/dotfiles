require("luasnip.session.snippet_collection").clear_snippets("html")

local ls = require("luasnip")
local i = ls.insert_node
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

-- fmt( ({}), nodes)
ls.add_snippets("html", {
	s(
		"html5",
		fmt(
			[[
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width={}, initial-scale={}">
	<title>{}</title>
</head>
<body>
	{}
</body>
</html>
]],
			{
				i(1, "device-width"),
				i(2, "1.0"),
				i(3, "Document"),
				i(4, ""),
			}
		)
	),
})
