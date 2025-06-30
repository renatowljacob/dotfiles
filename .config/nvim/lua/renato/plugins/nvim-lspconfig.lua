return {
    {
        -- LSP Configuration & Plugins
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        cmd = { "LspInfo", "LspStart", "Mason" },
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for Neovim
            -- Mason must be loaded before its dependents so we need to set it up here.
            -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
            { "mason-org/mason.nvim", opts = {} },
            "mason-org/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            "saghen/blink.cmp",

            -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
            -- used for completion, annotations and signatures of Neovim APIs
            {
                "folke/lazydev.nvim",
                opts = {
                    library = {
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                        {
                            path = "/usr/share/awesome/lib",
                            words = {
                                "awesome%.",
                                "awful%.",
                                "beautiful%.",
                                "gears%.",
                                "menubar%.",
                                "naughty%.",
                                "wibox%.",
                            },
                        },
                    },
                },
            },
        },
        config = function()
            -- Brief aside: **What is LSP?**
            --
            -- LSP is an initialism you've probably heard, but might not understand what it is.
            --
            -- LSP stands for Language Server Protocol. It's a protocol that helps editors
            -- and language tooling communicate in a standardized fashion.
            --
            -- In general, you have a "server" which is some tool built to understand a particular
            -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
            -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
            -- processes that communicate with some "client" - in this case, Neovim!
            --
            -- LSP provides Neovim with features like:
            --  - Go to definition
            --  - Find references
            --  - Autocompletion
            --  - Symbol Search
            --  - and more!
            --
            -- Thus, Language Servers are external tools that must be installed separately from
            -- Neovim. This is where `mason` and related plugins come into play.
            --
            -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
            -- and elegantly composed help section, `:help lsp-vs-treesitter`

            -- Enable the following language servers
            --  Feel free to add/remove any LSPs that you want in RUNTIME_PATH/lsp. They will automatically be installed.
            --
            --  Add any additional override configuration in their respective tables. Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
            local ensure_installed = {}

            for server, _ in vim.fs.dir(vim.env.XDG_CONFIG_HOME .. "/nvim/lsp") do
                local server_name = vim.fn.fnamemodify(server, ":t:r")
                table.insert(ensure_installed, server_name)
            end

            -- You can add other tools here that you want Mason to install
            -- for you, so that they are available from within Neovim.
            vim.list_extend(ensure_installed, {
                -- Debuggers
                "cpptools", -- GDB setup
                "java-debug-adapter",
                -- Formatters
                "clang-format",
                "prettier",
                "shfmt",
                "stylua",
                -- Linters
                "shellcheck",
                -- Testing
                "java-test",
            })

            require("mason-tool-installer").setup({
                ensure_installed = ensure_installed,
            })

            require("mason-lspconfig").setup({
                automatic_enable = {
                    exclude = { "jdtls" },
                },
                ensure_installed = {},
            })
        end,
    },
}
