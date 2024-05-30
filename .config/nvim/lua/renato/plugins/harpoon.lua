return {
	"theprimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{
			"<leader>ha",
			function()
				require("harpoon"):list():add()
			end,
			desc = "[H]arpoon - [A]dd Buffer",
		},
		{
			"<leader>hm",
			function()
				require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
			end,
			desc = "[H]arpoon = Toggle [M]enu",
		},
		{
			"<leader>hh",
			function()
				require("harpoon"):list():select(1)
			end,
			desc = "[H]arpoon - 1st file",
		},
		{
			"<leader>hj",
			function()
				require("harpoon"):list():select(2)
			end,
			desc = "[H]arpoon - 2nd file",
		},
		{
			"<leader>hk",
			function()
				require("harpoon"):list():select(3)
			end,
			desc = "[H]arpoon - 3rd file",
		},
		{
			"<leader>hl",
			function()
				require("harpoon"):list():select(4)
			end,
			desc = "[H]arpoon - 4th file",
		},
		{
			"<leader>hp",
			function()
				require("harpoon"):list():prev()
			end,
			desc = "[H]arpoon - [P]revious File",
		},
		{
			"<leader>hn",
			function()
				require("harpoon"):list():next()
			end,
			desc = "[H]arpoon - [N]ext File",
		},
	},
}
