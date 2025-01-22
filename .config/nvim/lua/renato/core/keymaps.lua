-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set <space> as the leader key
-- Set \ as the local leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local helpers = require("renato.core.helpers")

-- Useful keymaps for config testing and plugin development
vim.keymap.set("n", "<leader>ns", "<cmd>source %<CR>", { desc = "Source file" })
vim.keymap.set("n", "<leader>nx", ":.lua<CR>", { desc = "Execute lua line" })
vim.keymap.set("v", "<leader>nx", ":lua<CR>", { desc = "Execute lua lines" })

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>dd", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle Diagnostics" })
vim.keymap.set(
    "n",
    "<leader>de",
    vim.diagnostic.open_float,
    { desc = "Show diagnostic Error messages" }
)
vim.keymap.set(
    "n",
    "<leader>dq",
    vim.diagnostic.setloclist,
    { desc = "Open diagnostic Quickfix list" }
)

-- Open/delete operations
vim.keymap.set("n", "<leader>obd", function()
    require("mini.bufremove").delete()
end, { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>otn", "<cmd>tabnew<CR>", { desc = "New Tab" })
vim.keymap.set("n", "<leader>otd", "<cmd>tabclose<CR>", { desc = "Delete Tab" })

-- CD to buffer directory
vim.keymap.set("n", "<leader>ocd", function()
    local bufpath = vim.fs.dirname(vim.api.nvim_buf_get_name(0)) or nil
    if bufpath == nil then
        return nil
    end

    local cwd = vim.fn.getcwd()
    if cwd == bufpath then
        vim.notify("Already in buffer directory")
        return nil
    end

    local rootdir = helpers.fs.find_root(cwd, bufpath)

    vim.fn.chdir(bufpath)
    vim.notify("Changed to " .. bufpath:sub(#rootdir + 2) .. " directory")
end, { desc = "Change to current buffer directory" })

-- Buffer, windows and tabs navigation
vim.keymap.set("n", "[b", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "[t", "<cmd>tabprevious<CR>", { desc = "Previous Tab" })
vim.keymap.set("n", "]t", "<cmd>tabNext<CR>", { desc = "Next Tab" })
vim.keymap.set(
    { "n", "v" },
    "<C-h>",
    "<C-w><C-h>",
    { desc = "Move focus to the left window" }
)
vim.keymap.set(
    { "n", "v" },
    "<C-l>",
    "<C-w><C-l>",
    { desc = "Move focus to the right window" }
)
vim.keymap.set(
    { "n", "v" },
    "<C-j>",
    "<C-w><C-j>",
    { desc = "Move focus to the lower window" }
)
vim.keymap.set(
    { "n", "v" },
    "<C-k>",
    "<C-w><C-k>",
    { desc = "Move focus to the upper window" }
)

-- Terminal keymaps
vim.keymap.set("n", "<C-t><C-n>", function()
    vim.cmd.terminal()
end, { desc = "New terminal" })
vim.keymap.set("n", "<C-t><C-t>", function()
    require("snacks").terminal()
end)
vim.keymap.set(
    "t",
    "<Esc><Esc>",
    "<C-\\><C-n>",
    { desc = "Exit terminal mode" }
)
vim.keymap.set("t", "<S-space>", "<space>") -- Prevent typos

-- Center screen after certain motions
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz")
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz")
vim.keymap.set({ "n", "v" }, "<C-f>", "<C-f>zz")
vim.keymap.set({ "n", "v" }, "<C-b>", "<C-b>zz")
vim.keymap.set({ "n", "v" }, "<C-o>", "<C-o>zz")
vim.keymap.set({ "n", "v" }, "<C-i>", "<C-i>zz")
vim.keymap.set("n", "{", "{zz")
vim.keymap.set("n", "}", "}zz")
vim.keymap.set("n", "(", "(zz")
vim.keymap.set("n", ")", ")zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

-- Misc

-- Change diagraph key
vim.keymap.set("i", "<C-k>", "<C-b>")
-- Clear search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- Command-line window
vim.keymap.set("n", "q;", "q:")
-- Toggle spellchecking
vim.keymap.set(
    "n",
    "<leader>dl",
    "<cmd>setlocal invspell<CR>",
    { desc = "Toggle Spellchecking" }
)

-- Debugging
vim.keymap.set(
    "n",
    "<leader>tm",
    "<cmd>messages<CR>",
    { desc = "Show messages" }
)

-- Plugins

-- Toggle highlight color
vim.keymap.set(
    "n",
    "<leader>dh",
    "<cmd>HighlightColors Toggle<CR>",
    { desc = "Toggle Highlight Colors" }
)
-- Go to Neorg index file
vim.keymap.set(
    "n",
    "<localleader>nx",
    "<cmd>Neorg index<CR>",
    { desc = "Go to index file" }
)
-- Auto Session
vim.keymap.set(
    "n",
    "<leader>ps",
    "<cmd>SessionSave<CR>",
    { desc = "Save session" }
)
vim.keymap.set(
    "n",
    "<leader>sS",
    "<cmd>SessionSearch<CR>",
    { desc = "Search session" }
)
-- Baredot
vim.keymap.set(
    "n",
    "gG",
    "<cmd>Baredot toggle<CR>",
    { desc = "Toggle dotfiles" }
)
