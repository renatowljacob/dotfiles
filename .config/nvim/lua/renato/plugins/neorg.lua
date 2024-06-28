return {
	"nvim-neorg/neorg",
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
			["core.keybinds"] = {
				config = {
					neorg_leader = "<leader>n",
					hook = function(keybinds)
						keybinds.remap_key("norg", "n", "<C-Space>", "<localleader>nt")
					end,
				},
			},
		},
	},
}
