-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>dd", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle Diagnostics" })
vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, { desc = "Show diagnostic Error messages" })
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Open diagnostic Quickfix list" })

-- Open Netrw (overriden by tfm keymap, fallback)
vim.keymap.set("n", "<leader>lf", vim.cmd.Explore, { desc = "Netrw" })
vim.keymap.set("n", "<leader>lv", vim.cmd.Lexplore, { desc = "Netrw on the left side" })

-- View next/previous buffer in the list
vim.keymap.set("n", "[b", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("n", "TT", vim.cmd.terminal, { desc = "Enter terminal mode" })
vim.keymap.set("t", "TQ", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Center screen after certain motions
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz")
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz")
vim.keymap.set({ "n", "v" }, "<C-f>", "<C-f>zz")
vim.keymap.set({ "n", "v" }, "<C-b>", "<C-b>zz")
vim.keymap.set({ "n", "v" }, "<C-o>", "<C-o>zz")
vim.keymap.set({ "n", "v" }, "<C-i>", "<C-i>zz")
vim.keymap.set({ "n", "v" }, "{", "{zz")
vim.keymap.set({ "n", "v" }, "}", "}zz")
vim.keymap.set({ "n", "v" }, "(", "(zz")
vim.keymap.set({ "n", "v" }, ")", ")zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

-- Clear search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Change diagraph key
vim.keymap.set("i", "<C-k>", "<C-b>")

-- Neorg keymap
vim.keymap.set("n", "<leader>nx", "<cmd>Neorg index<CR>", { desc = "Go to index file" })

-- Toggle highlight color
vim.keymap.set("n", "<leader>dh", "<cmd>HighlightColors Toggle<CR>", { desc = "Toggle Highlight Colors" })

-- Funny calculator
-- https://www.reddit.com/r/neovim/comments/1d8yeb0/simple_calculator_in_neovim/
vim.keymap.set("i", "<C-.>", function()
	vim.ui.input({ prompt = "Calculator: " }, function(input)
		local calc = load("return " .. (input or ""))()
		if calc then
			vim.api.nvim_feedkeys(tostring(calc), "i", true)
		end
	end)
end)
