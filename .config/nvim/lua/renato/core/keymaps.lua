-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set <space> as the leader key
-- Set \ as the local leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Useful keymaps for config testing and plugin development
vim.keymap.set("n", "<leader>ns", "<cmd>source %<CR>", { desc = "Source file" })
vim.keymap.set("n", "<leader>nx", ":.lua<CR>", { desc = "Execute lua line" })
vim.keymap.set("v", "<leader>nx", ":lua<CR>", { desc = "Execute lua lines" })

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>dd", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle Diagnostics" })
vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, { desc = "Show diagnostic Error messages" })
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Open diagnostic Quickfix list" })

-- Open netrw
vim.keymap.set("n", "<leader>lf", vim.cmd.Explore, { desc = "Netrw" })
vim.keymap.set("n", "<leader>lv", vim.cmd.Lexplore, { desc = "Netrw on the left side" })

-- Delete buffer
vim.keymap.set("n", "<leader>obd", function()
	require("mini.bufremove").delete()
end, { desc = "Delete buffer" })

-- Change to next/previous buffer in the list
vim.keymap.set("n", "[b", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })

vim.keymap.set("n", "<leader>otn", "<cmd>tabnew<CR>", { desc = "New Tab" })
vim.keymap.set("n", "<leader>otd", "<cmd>tabclose<CR>", { desc = "Delete Tab" })

-- Change to next/previous tab in the list
vim.keymap.set("n", "[t", "<cmd>tabprevious<CR>", { desc = "Previous Tab" })
vim.keymap.set("n", "]t", "<cmd>tabNext<CR>", { desc = "Next Tab" })

-- CD to current buffer path
vim.keymap.set("n", "<leader>ocd", function()
	local bufpath = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
	local cwd = vim.fn.getcwd()

	if cwd == bufpath then
		vim.notify("Already in buffer directory")
		return
	end

	local rootdir = require("renato.core.helpers").find_root(cwd, bufpath)

	vim.fn.chdir(bufpath)
	vim.notify("Changed to " .. bufpath:sub(#rootdir + 2) .. " directory")
end, { desc = "Change to current buffer directory" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
vim.keymap.set("n", "<C-t><C-n>", vim.cmd.terminal, { desc = "New terminal" })
vim.keymap.set("n", "<C-t><C-t>", function()
	require("snacks.terminal").toggle()
end, { desc = "Toggle terminal" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Workaround to not to delete the whole line after a typo
vim.keymap.set("t", "<S-space>", "<space>")

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set({ "n", "v" }, "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set({ "n", "v" }, "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set({ "n", "v" }, "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set({ "n", "v" }, "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

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

-- Toggle highlight color
vim.keymap.set("n", "<leader>dh", "<cmd>HighlightColors Toggle<CR>", { desc = "Toggle Highlight Colors" })

-- Toggle spellchecking
vim.keymap.set("n", "<leader>dl", "<cmd>setlocal invspell<CR>", { desc = "Toggle Spellchecking" })

-- Neorg keymap
vim.keymap.set("n", "<localleader>nx", "<cmd>Neorg index<CR>", { desc = "Go to index file" })

-- Telescope auto-session
vim.keymap.set("n", "<leader>sS", "<cmd>SessionSearch<CR>", { desc = "Search Session" })
