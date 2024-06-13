require("luasnip.session.snippet_collection").clear_snippets("html")

local ls = require("luasnip")
local i = ls.insert_node
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("html", {
	s(
		{
			trig = "html5",
			docstring = {
				"<!DOCTYPE html>",
				"<html lang='en'>",
				"\t<head>",
				"\t\t<meta charset='UTF-8'>",
				"\t\t<meta name='viewport' content='width=device-width, initial-scale=1.0'>",
				"\t\t<title>Document</title>",
				"\t</head>",
				"\t<body>",
				"\t\tDocument body",
				"\t</body>",
				"</html>",
			},
		},
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
