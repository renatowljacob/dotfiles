---@module 'snacks'

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set <space> as the leader key
-- Set \ as the local leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local helpers = require("renato.core.helpers")
local dotbare = helpers.cmd.dotbare

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
    Snacks.bufdelete()
end, { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>oba", function()
    Snacks.bufdelete.all()
end, { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>obo", function()
    Snacks.bufdelete.other()
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

-- Windows and tabs navigation
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
vim.keymap.set("n", "<C-t><C-t>", function()
    Snacks.terminal()
end, { desc = "Toggle terminal" })

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

--   Change diagraph key
vim.keymap.set("i", "<C-k>", "<C-b>")
--   Clear search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
--   Command-line window
vim.keymap.set("n", "q;", "q:")
--   Toggle spellchecking
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

--   Toggle highlight color
vim.keymap.set(
    "n",
    "<leader>dh",
    "<cmd>HighlightColors Toggle<CR>",
    { desc = "Toggle Highlight Colors" }
)
--   Auto Session
vim.keymap.set(
    "n",
    "<leader>ps",
    "<cmd>SessionSave<CR>",
    { desc = "Save session" }
)
--   SessionLens
vim.keymap.set(
    "n",
    "<leader>sS",
    "<cmd>SessionSearch<CR>",
    { desc = "Search session" }
)

-- Dotbare

--   Dotfiles management

--     Stage modified files
vim.keymap.set("n", "<leader>fa", function()
    dotbare("fadd")
end, { desc = "Git Add" })
--     Edit tracked files
vim.keymap.set("n", "<leader>ff", function()
    dotbare("fedit")
end, { desc = "Search Tracked Files" })
--     Grep tracked files
vim.keymap.set("n", "<leader>fg", function()
    dotbare("fgrep")
end, { desc = "Search Tracked Files By Grep" })
--     Select commit
vim.keymap.set("n", "<leader>fl", function()
    dotbare("flog")
end, { desc = "Git Log" })
--     Apply selected stash
vim.keymap.set("n", "<leader>fS", function()
    dotbare("fstash")
end, { desc = "Git Stash" })
--     (Un)stage modified files
vim.keymap.set("n", "<leader>fs", function()
    dotbare("fstat")
end, { desc = "Git Status" })

--   Git client

--     Stage modified files
vim.keymap.set("n", "<leader>ga", function()
    dotbare("fadd", { git = true })
end, { desc = "Git Add" })
--     Edit tracked files
vim.keymap.set("n", "<leader>gf", function()
    dotbare("fedit", { git = true })
end, { desc = "Search Tracked Files" })
--     Grep tracked files
vim.keymap.set("n", "<leader>gg", function()
    dotbare("fgrep", { git = true })
end, { desc = "Search Tracked Files By Grep" })
--     Select commit
vim.keymap.set("n", "<leader>gl", function()
    dotbare("flog", { git = true })
end, { desc = "Git Log" })
--     Apply selected stash
vim.keymap.set("n", "<leader>gS", function()
    dotbare("fstash", { git = true })
end, { desc = "Git Stash" })
--     (Un)stage modified files
vim.keymap.set("n", "<leader>gs", function()
    dotbare("fstat", { git = true })
end, { desc = "Git Status" })
