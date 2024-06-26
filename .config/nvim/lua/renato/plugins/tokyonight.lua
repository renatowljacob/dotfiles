return {
	-- You can easily change to a different colorscheme.
	-- Change the name of the colorscheme plugin below, and then
	-- change the command in the config to whatever the name of that colorscheme is.
	--
	-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
	"folke/tokyonight.nvim",
	priority = 1000, -- Make sure to load this before all the other start plugins.
	opts = {
		style = "night",
		transparent = true,
		styles = {
			floats = "transparent",
			sidebars = "transparent",
		},
	},
	init = function()
		-- Load the colorscheme here.
		-- Like many other themes, this one has different styles, and you could load
		-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
		vim.cmd.colorscheme("tokyonight")

		-- You can configure highlights by doing something like:
		vim.cmd.hi("DapStoppedLine guibg=#16161e")
		vim.cmd.hi("DebugPC guibg=#16161e")
		vim.cmd.hi("@neorg.tags.ranged_verbatim.name.word guifg=#545c7e")
		vim.cmd.hi("@neorg.tags.ranged_verbatim.begin guifg=#545c7e")
		vim.cmd.hi("@neorg.tags.ranged_verbatim.end guifg=#545c7e")
	end,
}
