---@module "snacks"

---@class MyApi Stuffed used in some places
---@field buf table Buffer-related functions
---@field ft table Filetype-related functions
local M = {}

M.buf = {}
M.ft = {}

---Document symbols using a language server (or Treesitter as a fallback)
---@param opts? snacks.picker.lsp.symbols.Config
function M.buf.document_symbols(opts)
    if
        not vim.tbl_isempty(
            vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
        )
    then
        return Snacks.picker.lsp_symbols(opts)
    end

    return Snacks.picker.treesitter()
end

---Gets the filetype of a C/C++ header file
---Useful for ambiguous .h files that are set the wrong filetype
---@param header_file string C/C++ filepath
---@return string? filetype C or C++ filetype
function M.ft.get_header_filetype(header_file)
    local file_basename = vim.fs.basename(header_file)
    local file_extension = vim.fs.ext(file_basename)

    -- Header file, no need to disambiguate
    if file_extension ~= "h" then
        return nil
    end

    local file_stem = file_basename:match("(.*)%..*")
    local same_stem_files = vim.fs.find(function(file, _)
        return file_stem == file:match("(.*)%..*")
    end, {
        limit = math.huge,
        type = "file",
        path = vim.fs.dirname(file_basename),
    })

    if vim.tbl_isempty(same_stem_files) then
        return nil
    end

    local cpp_extensions = { "cpp", "cxx", "c++", "cc", "cp", "C", "CPP", "H" } -- why
    for _, file in ipairs(same_stem_files) do
        for _, extension in ipairs(cpp_extensions) do
            if vim.fs.ext(file) == extension then
                return "cpp"
            end
        end
    end

    return "c"
end

---Sets the filetype of a C/C++ header buffer accordingly
---Useful for ambiguous .h files that are set the wrong filetype
---@param bufnr integer buffer number
function M.ft.set_header_filetype(bufnr)
    local filetype = M.ft.get_header_filetype(vim.api.nvim_buf_get_name(bufnr))
    if filetype ~= nil then
        vim.bo[bufnr].filetype = filetype
    end
end

return M
