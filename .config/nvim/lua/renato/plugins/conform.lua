return {
    {
        -- Autoformat
        "stevearc/conform.nvim",
        lazy = false,
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                -- Disable "format_on_save lsp_fallback" for languages that don't
                -- have a well standardized coding style. You can add additional
                -- languages here or re-enable it for the disabled ones.
                local disable_filetypes = { c = true, cpp = true }

                return {
                    timeout_ms = 500,
                    lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                }
            end,
            formatters_by_ft = {
                bash = { "shfmt" },
                c = { "clang-format" },
                cpp = { "clang-format" },
                css = { "prettier" },
                html = { "prettier" },
                lua = { "stylua" },
                sh = { "shfmt" },
                -- Conform can also run multiple formatters sequentially
                -- python = { "isort", "black" },
                --
                -- You can use a sub-list to tell conform to run *until* a formatter
                -- is found.
                -- javascript = { { "prettierd", "prettier" } },
            },
            formatters = {
                ["clang-format"] = {
                    condition = function()
                        return vim.fs.root(0, ".clang-format") ~= nil
                    end,
                },
                shfmt = {
                    prepend_args = {
                        "--binary-next-line",
                        "--func-next-line",
                        "--indent",
                        "4",
                        "--space-redirects",
                    },
                },
            },
        },
    },
}
