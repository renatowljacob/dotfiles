return {
	"nvim-neorg/neorg",
	dependencies = { { "nvim-lua/plenary.nvim" }, { "nvim-neorg/neorg-telescope" } },
	version = "*",
	ft = "norg",
	cmd = { "Neorg" },
	opts = {
		load = {
			["core.defaults"] = {},
			["core.concealer"] = {
				config = {
					icons = {
						todo = {
							cancelled = {
								icon = "",
							},
							done = {
								icon = "",
							},
							pending = {
								icon = "󰅐",
							},
							recurring = {
								icon = "",
							},
							uncertain = {
								icon = "",
							},
						},
					},
				},
			},
			["core.dirman"] = {
				config = {
					workspaces = {
						notes = "~/Documents/notes",
					},
					default_workspace = "notes",
				},
			},
		},
	},
}
