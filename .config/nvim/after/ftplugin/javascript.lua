local winid = vim.api.nvim_get_current_win()
local current_win_opt = vim.wo[winid][0]

current_win_opt.colorcolumn = "120"

local myapi = require("myapi")

vim.keymap.set("i", "t", function()
    vim.api.nvim_feedkeys("t", "n", true)
    myapi.ft.set_async()
end, { desc = "Add async to function declaration" })
