-- Debugging function
-- Talk about overkill
P = function(var)
	local version = vim.version.parse(vim.system({ "nvim", "--version" }, { text = true }):wait().stdout)

	if vim.version.lt(version, "0.11.0") then
		print(vim.inspect(var))
	else
		vim.print(var)
	end
end

local M = {}

--- Find root directory between two directories
--- @param cwd string Cwd path
--- @param path string Buffer directory path
--- @return string? root_dir Root directory shared between two paths
function M.find_root(cwd, path)
	if path:sub(1, 1) ~= "/" then
		return nil
	end

	local match = cwd:match(path)

	if not match then
		return M.find_root(cwd, vim.fs.dirname(path))
	else
		return match
	end
end

return M
