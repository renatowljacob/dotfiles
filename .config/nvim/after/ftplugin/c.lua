vim.wo[vim.api.nvim_get_current_win()][0].foldenable = true

local myapi = require("renato.core.myapi")
local bufnr = vim.api.nvim_get_current_buf()

local file =
    myapi.ft.c.get_source(vim.fs.basename(vim.api.nvim_buf_get_name(bufnr)))

if file then
    local extension = file:match(".*%.(%w+)")
    if extension == "cpp" then
        vim.bo[bufnr].filetype = "cpp"
    else
        vim.bo[bufnr].filetype = "c"
    end
end
