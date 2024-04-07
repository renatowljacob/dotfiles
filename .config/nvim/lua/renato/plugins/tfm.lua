return {
	"rolv-apneseth/tfm.nvim",
	opts = {
		file_manager = "lf",
		replace_netrw = false,
		enable_cmds = true,
	},
	keys = {
		{
			"<leader>lf",
			"<cmd>Tfm<CR>",
			desc = "LF",
		},
		{
			"<leader>ls",
			"<cmd>TfmSplit<CR>",
			desc = "LF - horizonal split",
		},
		{
			"<leader>lv",
			"<cmd>TfmVsplit<CR>",
			desc = "LF - vertical split",
		},
		{
			"<leader>lS",
			"<cmd>new<CR><cmd>Tfm<CR>",
			desc = "LF - test",
		},
	},
}
