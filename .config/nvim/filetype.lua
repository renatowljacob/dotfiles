local set_indent = function(pattern, indent)
	vim.api.nvim_create_autocmd("Filetype", {
		pattern = pattern,
		callback = function()
			if pattern == "c" then
				vim.o.cindent = true
			end

			vim.schedule(function()
				vim.bo.tabstop = indent
				vim.bo.shiftwidth = indent
			end)
		end,
	})
end

set_indent({ "html", "css", "lua", "yaml", "sql" }, 2)
set_indent({ "python", "javascript" }, 4)
