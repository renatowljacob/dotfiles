return {
	"brenoprata10/nvim-highlight-colors",
	ft = { "css", "html", "javascript" },
	cmd = "HighlightColors",
	opts = {
		---@usage 'background'|'foreground'|'virtual'
		render = "background",
		virtual_symbol = "■",
		enable_named_colors = true,
		enable_tailwind = true,
	},
}
