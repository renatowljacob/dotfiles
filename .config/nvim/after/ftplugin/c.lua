vim.wo[vim.api.nvim_get_current_win()][0].foldenable = true

local bufnr = vim.api.nvim_get_current_buf()
local basename = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))
local extension = basename:match(".*%.(%w+)")
local stem = basename:match("(.*)%.%w+")

if extension == "h" then
    local file = vim.fs.find(function(file, _)
        return stem == file:match("(.*)%.%w+")
    end, { type = "file", path = vim.fs.dirname(basename) })

    if vim.tbl_isempty(file) then
        return
    end

    stem = file[1]:match(".*%.(%w+)")

    if stem == "c" then
        vim.bo[bufnr].filetype = "c"
    elseif stem == "cpp" then
        vim.bo[bufnr].filetype = "cpp"
    end
end
