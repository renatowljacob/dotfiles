---@param str string
local function gh(str)
    return "https://github.com/" .. str
end

vim.pack.add({
    -- Completion
    {
        src = gh("saghen/blink.cmp"),
        version = vim.version.range("1"),
    },

    -- Theming
    gh("folke/tokyonight.nvim"),
    gh("HiPhish/rainbow-delimiters.nvim"),
    gh("nvim-tree/nvim-web-devicons"),

    -- Highlighting
    gh("brenoprata10/nvim-highlight-colors"),
    gh("renatowljacob/sentiment.nvim"),

    -- LSP
    gh("neovim/nvim-lspconfig"),
    gh("folke/lazydev.nvim"),

    -- Formatting/Linting
    gh("stevearc/conform.nvim"),
    gh("mfussenegger/nvim-lint"),

    -- Treesitter
    {
        src = gh("nvim-treesitter/nvim-treesitter"),
        version = "main",
    },
    gh("nvim-treesitter/nvim-treesitter-context"),

    -- DAP
    gh("mfussenegger/nvim-dap"),
    gh("rcarriga/nvim-dap-ui"),
    gh("theHamsta/nvim-dap-virtual-text"),

    -- Language-specific
    gh("mfussenegger/nvim-jdtls"),
    gh("windwp/nvim-ts-autotag"),

    -- Mason/Package Manager
    gh("mason-org/mason.nvim"),
    gh("mason-org/mason-lspconfig.nvim"),
    gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
    gh("jay-babu/mason-nvim-dap.nvim"),

    -- QOL
    gh("folke/which-key.nvim"),
    gh("stevearc/quicker.nvim"),
    gh("tpope/vim-sleuth"),

    -- Bundles
    gh("nvim-mini/mini.nvim"),
    gh("folke/snacks.nvim"),

    -- Miscellaneous
    gh("lewis6991/gitsigns.nvim"),

    -- Dependencies
    gh("nvim-neotest/nvim-nio"),
})
