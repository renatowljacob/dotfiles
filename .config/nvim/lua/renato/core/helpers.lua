-- Functions used in my config

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

	return match or M.find_root(cwd, vim.fs.dirname(path))
end

return M
