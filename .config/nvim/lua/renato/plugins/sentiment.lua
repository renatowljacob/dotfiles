return {
	{
		"utilyre/sentiment.nvim",
		event = "VeryLazy",
		opts = {
			delay = 30,
			limit = 100,
			pairs = {
				{ "(", ")" },
				{ "{", "}" },
				{ "[", "]" },
			},
		},
		init = function()
			vim.schedule(function()
				require("tokyonight.colors")
				vim.g.loaded_matchparen = 1
				vim.cmd.hi("MatchParen guifg=none guibg=#3b4261")
			end)
		end,
	},
}
