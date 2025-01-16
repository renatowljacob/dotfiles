return {
	{
		"brenoprata10/nvim-highlight-colors",
		opts = {
			---@usage 'background'|'foreground'|'virtual'
			render = "background",
			virtual_symbol = "■",
			enable_named_colors = vim.bo.filetype == "css",
			enable_hsl_colors = vim.bo.filetype == "css",
			enable_rgb_colors = vim.bo.filetype == "css",
			enable_tailwind = vim.bo.filetype == "css",
			exclude_buftypes = { "nofile" },
		},
	},
}
