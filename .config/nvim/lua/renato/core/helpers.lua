-- Functions used in my config

---@class Helpers
---@field buf table Buffer functions
---@field fs table Filesystem functions
local M = {}

M.buf = {}
M.fs = {}

---Get line and buffer number from a quickfix list item
---@return integer? bufnr, integer? lnum Buffer and line number
---If no quickfix list is found, nil is returned instead
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
---@param lnum number Line number to be highlighted
---@param opts? table Optional parameters
---              - higroup
---              - timeout in ms
---@return nil
function M.buf.highlight_line(bufnr, lnum, opts)
	opts = opts or {}

	local higroup = opts.higroup or "IncSearch"
	local namespace = vim.api.nvim_create_namespace("highlight_quickfix")
	local timeout = opts.timeout or 150
	local timer ---@type uv.uv_timer_t
	local winid = vim.fn.bufwinid(bufnr)

	local clear_hl = function()
		pcall(vim.api.nvim_buf_clear_namespace, bufnr, namespace, 0, -1)
		pcall(vim.api.nvim__win_del_ns, vim.fn.bufwinid(bufnr), namespace)
	end

	vim.api.nvim__win_add_ns(winid, namespace)

	vim.highlight.range(bufnr, namespace, higroup, { lnum, 0 }, { lnum, vim.fn.col("$") })

	if timer then
		timer:close()
		assert(clear_hl)
		clear_hl()
	end

	timer = vim.defer_fn(clear_hl, timeout)
end

---Find root directory between two directories
---@param cwd string Cwd path
---@param bufpath string Buffer directory path
---@return string? root_dir Root directory shared between two paths
function M.fs.find_root(cwd, bufpath)
	for dir in vim.fs.parents(bufpath) do
		if cwd:match(dir) then
			return dir
		end
	end
end

return M
