return {
    {
        -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-context",
                opts = {
                    enable = true,
                    multiline_threshold = 1,
                },
            },
        },
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local filetypes = {
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
                "odin",
                "python",
                "vim",
                "vimdoc",
                "zsh",
            }

            require("nvim-treesitter").install(filetypes)

            -- No parser for these, just start treesitter
            vim.list_extend(filetypes, {
                "sh",
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = filetypes,
                callback = function()
                    vim.treesitter.start()
                end,
            })
        end,
    },
}
