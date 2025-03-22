-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

--  GLOBAL OPTIONS
vim.o.autoread = true
vim.o.diffopt = "internal,filler,closeoff,linematch:60"
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
vim.wo.colorcolumn = "80"

--  MISC
--       Diagnostic Config
--       See :help vim.diagnostic.Opts
vim.diagnostic.config({
    severity_sort = true,
    float = { border = "rounded", source = "if_many" },
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = vim.g.have_nerd_font and {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
    } or {},
    virtual_text = {
        source = "if_many",
        spacing = 2,
        format = function(diagnostic)
            local diagnostic_message = {
                [vim.diagnostic.severity.ERROR] = diagnostic.message,
                [vim.diagnostic.severity.WARN] = diagnostic.message,
                [vim.diagnostic.severity.INFO] = diagnostic.message,
                [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
        end,
    },
})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "single",
})

--       Netrw settings
vim.g.netrw_winsize = 30
vim.g.netrw_liststyle = 3
vim.g.netrw_preview = 1
vim.g.netrw_bufsettings = "noma nomod nu nobl nowrap ro rnu"
