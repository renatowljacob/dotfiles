-- Functions used in my config

---@class Helpers
---@field buf table Buffer functions
---@field fs table Filesystem functions
local M = {}

M.fs = {}
M.buf = {}

---Get line and buffer number from a quickfix list item
---@return integer? bufnr Buffer number
---@return integer? lnum Line number
---If no quickfix list is found, nil is return instead
function M.buf.get_qfline()
	---@type table
	local qflist = vim.fn.getqflist()

	if vim.tbl_isempty(qflist) then
		return nil
	end

	local index = vim.fn.getqflist({ idx = 0 }).idx
	local line = qflist[index]
	local bufnr, lnum = line.bufnr, line.lnum - 1

	return bufnr, lnum
end

---Apply highlight group to a line
---@param bufnr number Buffer that contains the line
---@param lnum number Number of the line to be highlighted
---@return nil
function M.buf.highlight_line(bufnr, lnum)
	local highlight = "IncSearch"
	local namespace = vim.api.nvim_create_namespace("highlight_quickfix")
	local timeout = 150
	local timer ---@type uv.uv_timer_t

	local clear_hl = function()
		pcall(vim.api.nvim_buf_clear_namespace, bufnr, namespace, 0, -1)
		pcall(vim.api.nvim__win_del_ns, vim.fn.bufwinid(bufnr), namespace)
	end

	local winid = vim.fn.bufwinid(bufnr)
	vim.api.nvim__win_add_ns(winid, namespace)

	vim.highlight.range(bufnr, namespace, highlight, { lnum, 0 }, { lnum, vim.fn.col("$") })

	if timer then
		timer:close()
		assert(clear_hl)
		clear_hl()
	end

	timer = vim.defer_fn(clear_hl, timeout)
end

---Find root directory between two directories
---@param cwd string Cwd path
---@param path string Buffer directory path
---@return string? root_dir Root directory shared between two paths
function M.fs.find_root(cwd, path)
	if path:sub(1, 1) ~= "/" then
		return nil
	end

	local match = cwd:match(path)

	return match or M.fs.find_root(cwd, vim.fs.dirname(path))
end

return M
