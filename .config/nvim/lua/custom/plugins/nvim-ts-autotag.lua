return {
	"windwp/nvim-ts-autotag",
	ft = {
		"html",
		"javascript",
		"javascriptreact",
		"markdown",
		"php",
		"typescript",
		"typescriptreact",
		"vue",
		"xml",
	},
	---@diagnostic disable-next-line: missing-fields
	require("nvim-treesitter.configs").setup({
		autotag = {
			enable = true,
		},
	}),
}
