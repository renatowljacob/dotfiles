local winid = vim.api.nvim_get_current_win()
local current_win_opt = vim.wo[winid][0]

current_win_opt.colorcolumn = "120"
