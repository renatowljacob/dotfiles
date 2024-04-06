local set_indent = function(pattern, indent)
	vim.api.nvim_create_autocmd("Filetype", {
		pattern = pattern,
		callback = function()
			vim.schedule(function()
				vim.bo.tabstop = indent
				vim.bo.shiftwidth = indent
			end)
		end,
	})
end

set_indent({ "html", "css" }, 2)
set_indent({ "c", "sh", "python", "javascript", "lua", "java" }, 4)
