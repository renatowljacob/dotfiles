return {
	"fedepujol/move.nvim",
	config = function()
		require('move').setup({
			line = {
				enable = true, -- Enables line movement
				indent = false -- Toggles indentation
			},
			block = {
				enable = true, -- Enables block movement
				indent = false -- Toggles indentation
			},
			word = {
				enable = false, -- Enables word movement
			},
			char = {
				enable = false -- Enables char movement
			},
		})

		local opts = { noremap = true, silent = true }
		-- Normal-mode commands
		vim.keymap.set('n', '<A-j>', ':MoveLine(1)<CR>', opts)
		vim.keymap.set('n', '<A-k>', ':MoveLine(-1)<CR>', opts)

		-- Visual-mode commands
		vim.keymap.set('v', '<A-j>', ':MoveBlock(1)<CR>', opts)
		vim.keymap.set('v', '<A-k>', ':MoveBlock(-1)<CR>', opts)
	end,
}
