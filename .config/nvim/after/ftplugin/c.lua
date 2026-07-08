local myapi = require("myapi")
local bufnr = vim.api.nvim_get_current_buf()

vim.cmd("compiler gcc")

vim.bo.tabstop = 4
myapi.ft.set_header_filetype(bufnr)

if vim.fs.root(0, ".clangd") then
    vim.lsp.enable("clangd")
end
