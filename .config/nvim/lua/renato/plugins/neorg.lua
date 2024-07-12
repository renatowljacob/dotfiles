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
			["core.keybinds"] = {
				config = {
					neorg_leader = "<leader>n",
					hook = function(keybinds)
						keybinds.remap_key("norg", "n", "<C-Space>", "<localleader>nt")
						keybinds.map("norg", "n", "<leader>nr", "<cmd>Neorg return<CR>")
						keybinds.map(
							"norg",
							"n",
							"<leader>nc",
							"<cmd>Neorg keybind all core.looking-glass.magnify-code-block<CR>"
						)
						keybinds.map("norg", "n", "<leader>nf", "<cmd>Telescope neorg find_linkable<CR>")
						keybinds.map("norg", "n", "<leader>nh", "<cmd>Telescope neorg search_headings<CR>")
					end,
				},
			},
		},
	},
}
