local win = vim.api.nvim_get_current_win()
local bufnr = vim.api.nvim_win_get_buf(win)

vim.bo.tabstop = 2
vim.bo.shiftwidth = 2

if vim.bo[bufnr].buftype == "" then
    vim.wo[win][0].spell = true
end

vim.opt_local.spelllang = { "en_us", "pt_br" }
