require("luasnip.session.snippet_collection").clear_snippets("css")

local ls = require("luasnip")
local i = ls.insert_node
local s = ls.snippet
local fmta = require("luasnip.extras.fmt").fmta

ls.add_snippets("css", {
    s(
        {
            name = "maxcolumns",
            trig = "maxcolumns",
            docstring = {
                "/* Control variables */",
                "--grid-max-col-count: 5;",
                "--grid-min-col-size: 100px;",
                "--grid-gap: 1rem;",
                "",
                "/* Alter the behavior through the variables above */",
                "",
                "--grid-col-size-calc: calc(",
                "(100% - var(--grid-gap) * var(--grid-max-col-count)) /",
                "var(--grid-max-col-count)",
                ");",
                "",
                "--grid-col-min-size-calc: min(",
                "100%,",
                "max(var(--grid-min-col-size), var(--grid-col-size-calc))",
                ");",
                "",
                "display: grid;",
                "grid-template-columns: repeat(",
                "auto-fit,",
                "minmax(var(--grid-col-min-size-calc), 1fr)",
                ");",
                "",
                "grid-auto-rows: minmax(calc(var(--min-height) / 2 - 2.5rem), 1fr);",
                "align-content: space-between;",
                "gap: var(--grid-gap);",
                "",
                "padding: 2rem;",
                "",
            },
        },
        fmta(
            [[
    /* Control variables */
    --grid-max-col-count: <>;
    --grid-min-col-size: <>;
    --grid-gap: <>;
    
    /* Alter the behavior through the control variables */
    --grid-col-size-calc: calc(
      (100% - var(--grid-gap) * var(--grid-max-col-count)) /
        var(--grid-max-col-count)
    );
    
    --grid-col-min-size-calc: min(
      100%,
      max(var(--grid-min-col-size), var(--grid-col-size-calc))
    );
    
    display: grid;
    grid-template-columns: repeat(
      auto-fit,
      minmax(var(--grid-col-min-size-calc), 1fr)
    );
    
    grid-auto-rows: minmax(calc(var(--min-height) / 2 - 2.5rem), 1fr);
    align-content: <>;
    gap: var(--grid-gap);
]],
            {
                i(1, "/* maximum columns */"),
                i(2, "/* minimum column size */"),
                i(3, "/* gap */"),
                i(4, "/* align-content */"),
            }
        )
    ),
})
