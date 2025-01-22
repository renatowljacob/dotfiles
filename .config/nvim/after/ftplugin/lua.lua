vim.wo[vim.api.nvim_get_current_win()][0].foldenable = true

vim.keymap.set("n", "<localleader>tl", function()
    require("osv").launch({ port = 8086 })
end)
