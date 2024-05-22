-- %{%v:lua.MiniStatusline.active()%}
-- %{%v:lua.MiniStatusline.active()%}%{%v:lua.MiniStatusline.inactive()%}
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Diagnostic keymaps
-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>dH", vim.diagnostic.hide, { desc = "[H]ide diagnostics" })
vim.keymap.set("n", "<leader>dD", vim.diagnostic.show, { desc = "Show [D]iagnostics" })

-- Open Netrw (overriden by tfm keymap, fallback)
vim.keymap.set("n", "<leader>lf", vim.cmd.Explore, { desc = "Netrw" })
vim.keymap.set("n", "<leader>lv", vim.cmd.Lexplore, { desc = "Netrw on the left side" })

-- View next/previous buffer in the list
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Buffer: [P]revious buffer" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Buffer: [N]ext buffer" })

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
vim.keymap.set("n", "Z", "i<enter><Esc>")

-- Clear search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
