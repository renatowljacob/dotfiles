-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Netrw settings
vim.g.netrw_winsize = 30
vim.g.netrw_liststyle = 3
vim.g.netrw_preview = 1
vim.g.netrw_bufsettings = "noma nomod nu nobl nowrap ro rnu"

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = "unnamedplus"

-- Enable break indent
vim.opt.breakindent = true

-- Wrap words according to window size
vim.opt.linebreak = true
vim.opt.wrap = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the
-- search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

vim.opt.colorcolumn = "80"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = false
vim.opt.splitbelow = false

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = {
	trail = "·",
	tab = "» ",
	eol = "↴",
	leadmultispace = "• ",
}
vim.opt.showbreak = "↳"

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Set highlight on search
vim.opt.hlsearch = true

vim.opt.scrolloff = 10

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Floating windows border configuration
vim.diagnostic.config({
	float = { border = "rounded" },
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "single",
})
