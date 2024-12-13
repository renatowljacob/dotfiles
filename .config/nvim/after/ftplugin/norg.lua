vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2

vim.opt_local.list = false
vim.opt_local.showbreak = ""

vim.opt_local.wrap = false

vim.wo.conceallevel = 2
vim.wo.foldlevel = 1
vim.o.foldnestmax = 20
vim.o.foldenable = true

vim.opt_local.spell = true
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
