-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

--  GLOBAL OPTIONS
vim.o.autoread = true
vim.o.hlsearch = true
vim.o.scrolloff = 10
vim.o.timeoutlen = 300
vim.o.updatetime = 250
--      Global clipboard
vim.o.clipboard = "unnamedplus"
--      Case options
vim.o.ignorecase = true
vim.o.smartcase = true
--      Preview substitutions live
vim.o.inccommand = "split"
--      Global statusline
vim.o.laststatus = 3
--      Enable mouse
vim.o.mouse = "a"
--      Don't show the mode, since it's already in the status line
vim.o.showmode = false
--      Identation
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 0
vim.o.expandtab = true
--      Save history
vim.o.undofile = true
--      Without noinsert, omnifunc breaks rainbow-delimiters :P idk
vim.opt.completeopt = {
	"menuone",
	"noinsert",
	"popup",
}
--      Session options
vim.opt.sessionoptions = {
	"blank",
	"buffers",
	"folds",
	"globals",
	"help",
	"localoptions",
	"options",
	"sesdir",
	"tabpages",
	"terminal",
	"winsize",
}

--  WINDOW OPTIONS
--      Folding
vim.wo.foldenable = false
vim.wo.foldtext = ""
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
--      Virtual chars
vim.wo.list = true
vim.opt.listchars = {
	trail = "·",
	tab = "» ",
	eol = "↴",
	leadmultispace = "• ",
}
vim.o.showbreak = "↳"
--      Relative numbering
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes"
--       Wrapping
vim.wo.wrap = true
vim.wo.linebreak = true
vim.wo.breakindent = true
--       Misc
vim.wo.colorcolumn = "81"

--  MISC
--       Floating windows border configuration
vim.diagnostic.config({
	float = { border = "rounded" },
})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "single",
})

--       Netrw settings
vim.g.netrw_winsize = 30
vim.g.netrw_liststyle = 3
vim.g.netrw_preview = 1
vim.g.netrw_bufsettings = "noma nomod nu nobl nowrap ro rnu"
