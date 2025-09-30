return {
    {
        -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            {
                "nvim-treesitter/nvim-treesitter-context",
                opts = {
                    enable = true,
                    multiline_threshold = 1,
                },
            },
        },
        branch = "master",
        build = ":TSUpdate",
        opts = {
            ensure_installed = {
                "bash",
                "c",
                "css",
                "go",
                "html",
                "java",
                "javascript",
                "lua",
                "luadoc",
                "markdown",
                "markdown_inline",
                "vim",
                "vimdoc",
            },
            auto_install = true,
            autotag = { enable = false },
            highlight = {
                enable = true,
            },
            indent = {
                enable = false,
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["aa"] = "@parameter.outer",
                        ["ia"] = "@parameter.inner",
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]c"] = "@class.outer",
                    },
                    goto_next_end = {
                        ["]F"] = "@function.outer",
                        ["]C"] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[c"] = "@class.outer",
                    },
                    goto_previous_end = {
                        ["[F"] = "@function.outer",
                        ["[C"] = "@class.outer",
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>dp"] = "@parameter.inner",
                    },
                    swap_previous = {
                        ["<leader>dP"] = "@parameter.inner",
                    },
                },
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<S-space>",
                    node_incremental = "<S-space>",
                    scope_incremental = "<C-s>",
                    node_decremental = "<M-space>",
                },
            },
        },
        config = function(_, opts)
            -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

            ---@diagnostic disable-next-line: missing-fields
            require("nvim-treesitter.configs").setup(opts)

            -- There are additional nvim-treesitter modules that you can use to interact
            -- with nvim-treesitter. You should go explore a few and see what interests you:
            --
            --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
            --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
            --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
        end,
    },
}
