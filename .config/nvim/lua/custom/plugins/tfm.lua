return {
	"rolv-apneseth/tfm.nvim",
	opts = {
		file_manager = "lf",
		replace_netrw = true,
		enable_cmds = true,
	},
	keys = {
		{
			"<leader>lf",
			":Tfm<CR>",
			desc = "LF",
		},
		{
			"<leader>ls",
			":TfmSplit<CR>",
			desc = "LF - horizonal split",
		},
		{
			"<leader>lv",
			":TfmVsplit<CR>",
			desc = "LF - vertical split",
		},
	},
}
