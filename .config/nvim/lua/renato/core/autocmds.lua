-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	desc = "Resize splits in window resize",
	group = vim.api.nvim_create_augroup("resize-splits", { clear = true }),
	callback = function()
		local current_tab = vim.fn.tabpagenr()

		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
	desc = "Update rainbow delimiters highlighting",
	group = vim.api.nvim_create_augroup("update-rainbow-delimiters", { clear = true }),
	callback = function()
		local plugins = require("lazy").plugins()

		for _, plugin in ipairs(plugins) do
			if plugin.name == "rainbow-delimiters.nvim" and plugin._.loaded then
				local rainbow_delimiters = require("rainbow-delimiters")

				rainbow_delimiters.disable(0)
				rainbow_delimiters.enable(0)
			end
		end
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	desc = "Set local options for terminal buffer",
	group = vim.api.nvim_create_augroup("set-terminal-opts", { clear = true }),
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
	end,
})
