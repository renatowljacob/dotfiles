---@module 'snacks'

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set <space> as the leader key
-- Set \ as the local leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local MyApi = require("myapi")

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
    { desc = "Show diagnostic error messages" }
)

vim.keymap.set("n", "<leader>dq", function()
    vim.diagnostic.setloclist({ open = false })
    require("quicker").toggle({ loclist = true })
end, { desc = "Open buffer-local diagnostic quickfix list" })

vim.keymap.set("n", "<leader>dw", function()
    vim.diagnostic.setqflist({ open = false })
    require("quicker").toggle()
end, { desc = "Open global diagnostic quickfix list" })

-- Buffer operations
vim.keymap.set("n", "<leader>bd", function()
    Snacks.bufdelete()
end, { desc = "Delete buffer" })

vim.keymap.set("n", "<leader>ba", function()
    Snacks.bufdelete.all()
end, { desc = "Delete all buffers" })

vim.keymap.set("n", "<leader>bt", function()
    Snacks.bufdelete.other()
end, { desc = "Delete all but this buffer" })

-- Tab operations
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New Tab" })
vim.keymap.set("n", "<leader>td", "<cmd>tabclose<CR>", { desc = "Close Tab" })

-- CD to buffer directory
-- TODO: proper relative path printing
vim.keymap.set("n", "<leader>cd", function()
    local bufpath = vim.fs.dirname(vim.api.nvim_buf_get_name(0)) or nil
    if not bufpath then
        return
    end

    local cwd = vim.fn.getcwd()
    if cwd == bufpath then
        vim.notify("Already in buffer directory")
        return
    end

    local rootdir = nil
    for dir in vim.fs.parents(bufpath) do
        if cwd:match(dir) then
            rootdir = dir
            break
        end
    end
    if not rootdir then
        return
    end

    vim.fn.chdir(bufpath)
    vim.notify("Changed to " .. bufpath:sub(#rootdir + 2) .. " directory")
end, { desc = "Change to current buffer directory" })

-- Buffer navigation
vim.keymap.set({ "n", "v", "o" }, "H", "^")
vim.keymap.set({ "n", "v", "o" }, "L", "$")
vim.keymap.set("n", "M", "<Plug>(MatchitNormalForward)")
vim.keymap.set("v", "M", "<Plug>(MatchitVisualForward)")
vim.keymap.set("o", "M", "<Plug>(MatchitOperationForward)")

-- Windows and tabs navigation
vim.keymap.set("n", "[t", "<cmd>tabprevious<CR>", { desc = "Previous Tab" })
vim.keymap.set("n", "]t", "<cmd>tabNext<CR>", { desc = "Next Tab" })

local function map_window(lhs, location)
    vim.keymap.set(
        { "n", "v" },
        lhs,
        "<C-w>" .. lhs,
        { desc = "Move focus to the " .. location .. " window" }
    )
end
map_window("<C-h>", "left")
map_window("<C-j>", "lower")
map_window("<C-k>", "upper")
map_window("<C-l>", "right")

-- Center screen after certain motions

---@param lhs string
---@param modes string[]?
local function map_center(lhs, modes)
    vim.keymap.set(modes or "n", lhs, lhs .. "zz")
end
map_center("<C-d>", { "n", "v" })
map_center("<C-u>", { "n", "v" })
map_center("<C-f>", { "n", "v" })
map_center("<C-b>", { "n", "v" })
map_center("<C-o>", { "n", "v" })
map_center("<C-i>", { "n", "v" })
map_center("{")
map_center("}")
map_center("(")
map_center(")")
map_center("n")
map_center("N")

-- Misc

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
