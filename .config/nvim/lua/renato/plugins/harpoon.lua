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
			desc = "Harpoon - Add Buffer",
		},
		{
			"<leader>hm",
			function()
				require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
			end,
			desc = "Harpoon = Toggle Menu",
		},
		{
			"<leader>hh",
			function()
				require("harpoon"):list():select(1)
			end,
			desc = "Harpoon - 1st file",
		},
		{
			"<leader>hj",
			function()
				require("harpoon"):list():select(2)
			end,
			desc = "Harpoon - 2nd file",
		},
		{
			"<leader>hk",
			function()
				require("harpoon"):list():select(3)
			end,
			desc = "Harpoon - 3rd file",
		},
		{
			"<leader>hl",
			function()
				require("harpoon"):list():select(4)
			end,
			desc = "Harpoon - 4th file",
		},
		{
			"<leader>hp",
			function()
				require("harpoon"):list():prev()
			end,
			desc = "Harpoon - Previous File",
		},
		{
			"<leader>hn",
			function()
				require("harpoon"):list():next()
			end,
			desc = "Harpoon - Next File",
		},
	},
}
