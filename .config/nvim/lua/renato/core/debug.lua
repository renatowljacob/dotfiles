-- Global functions for debugging

---Print var value
---@param var any
P = function(var)
	local version = vim.version.parse(vim.system({ "nvim", "--version" }, { text = true }):wait().stdout)

	-- Talk about overkill
	if vim.version.lt(version, "0.11.0") then
		print(vim.inspect(var))
	else
		vim.print(var)
	end
end
