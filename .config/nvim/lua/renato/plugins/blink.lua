return {
    {
        "saghen/blink.cmp",
        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                build = (function()
                    -- Build Step is needed for regex support in snippets.
                    -- This step is not supported in many windows environments.
                    -- Remove the below condition to re-enable on windows.
                    if
                        vim.fn.has("win32") == 1
                        or vim.fn.executable("make") == 0
                    then
                        return
                    end
                    return "make install_jsregexp"
                end)(),
            },
        },

        -- use a release tag to download pre-built binaries
        version = "*",
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept, C-n/C-p for up/down)
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys for up/down)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-e: Hide menu
            -- C-k: Toggle signature help (not used here)
            --
            -- See the full "keymap" documentation for information on defining your own keymap.
            --
            keymap = {
                preset = "default",
                ["<C-j>"] = { "snippet_forward" },
                ["<C-k>"] = { "snippet_backward" },
                ["<C-s>"] = { "show_signature", "hide_signature" },
            },
            cmdline = { completion = { menu = { auto_show = true } } },
            appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- Will be removed in a future release
                -- use_nvim_cmp_as_default = true,
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "normal",
            },
            completion = {
                menu = { border = "single" },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 300,
                    window = { border = "single" },
                },
                ghost_text = { show_with_menu = false },
            },
            snippets = { preset = "luasnip" },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = function()
                    local success, node = pcall(vim.treesitter.get_node)

                    if
                        success
                        and node
                        and vim.tbl_contains(
                            { "comment", "line_comment", "block_comment" },
                            node:type()
                        )
                    then
                        return { "buffer" }
                    else
                        return { "snippets", "lsp", "path", "buffer" }
                    end
                end,
                per_filetype = { sql = { "dadbod" } },
                providers = {
                    dadbod = {
                        name = "Dadbod",
                        module = "vim_dadbod_completion.blink",
                    },
                },
            },
            signature = {
                enabled = true,
                window = { border = "single" },
            },

            -- Blink.cmp uses a Rust fuzzy matcher by default for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = {
                implementation = "prefer_rust_with_warning",
                sorts = {
                    function(a, b)
                        local source_priority = {
                            snippets = 4,
                            lsp = 3,
                            path = 2,
                            buffer = 1,
                        }

                        local a_priority = source_priority[a.source_id]
                        local b_priority = source_priority[b.source_id]

                        if a_priority ~= b_priority then
                            return a_priority > b_priority
                        end
                    end,
                    "score",
                    "sort_text",
                },
            },
        },
        config = function(_, opts)
            require("blink.cmp").setup(opts)

            require("luasnip.config").setup({
                update_events = { "TextChanged", "TextChangedI" },
            })

            require("luasnip.loaders.from_lua").lazy_load({
                paths = { vim.fn.stdpath("config") .. "/lua/renato/snippets" },
            })

            vim.keymap.set({ "i", "s" }, "<C-,>", "<Plug>luasnip-prev-choice")
            vim.keymap.set({ "i", "s" }, "<C-;>", "<Plug>luasnip-next-choice")
        end,
        opts_extend = { "sources.default" },
    },
}
