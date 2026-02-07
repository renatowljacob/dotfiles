local myapi = require("renato.core.myapi")
local bufnr = vim.api.nvim_get_current_buf()

myapi.ft.set_header_filetype(bufnr)

if vim.fs.root(0, ".clangd") then
    vim.lsp.enable("clangd")
end
