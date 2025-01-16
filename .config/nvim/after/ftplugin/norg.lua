local winid = vim.api.nvim_get_current_win()
local current_win_opt = vim.wo[winid][0]

vim.bo.shiftwidth = 2
vim.bo.tabstop = 2

current_win_opt.list = false
vim.wo.showbreak = ""

current_win_opt.wrap = false

current_win_opt.conceallevel = 2
current_win_opt.foldlevel = 1
current_win_opt.foldnestmax = 20
current_win_opt.foldenable = true

current_win_opt.spell = true
vim.opt_local.spelllang = { "en_us", "pt_br" }

vim.keymap.set("n", "<localleader>nr", "<cmd>Neorg return<CR>", { buffer = true, desc = "Return to index" })
vim.keymap.set(
	"n",
	"<localleader>nl",
	"<cmd>Telescope neorg find_linkable<CR>",
	{ buffer = true, desc = "Search Elements" }
)
vim.keymap.set(
	"n",
	"<localleader>nh",
	"<cmd>Telescope neorg search_headings<CR>",
	{ buffer = true, desc = "Search [H]eadings" }
)
vim.keymap.set(
	"n",
	"<localleader>nt",
	"<Plug>(neorg.qol.todo-items.todo.task-cycle)",
	{ buffer = true, desc = "Cycle [T]ask" }
)
