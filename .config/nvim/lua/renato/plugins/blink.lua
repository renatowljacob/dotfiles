return {
    {
        "saghen/blink.cmp",

        -- use a release tag to download pre-built binaries
        version = "*",
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly
        -- rust with:
        -- build = 'nix run .#build-plugin',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' (recommended) for mappings similar to built-in
            -- completions (C-y to accept, C-n/C-p for up/down)
            -- 'super-tab' for mappings similar to vscode (tab to accept,
            -- arrow keys for up/down)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter'
            -- to accept
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-e: Hide menu
            -- C-k: Toggle signature help (not used here)
            --
            -- See the full "keymap" documentation for information on defining
            -- your own keymap.
            --
            keymap = {
                preset = "default",
                ["<Tab>"] = {},
                ["<S-Tab>"] = {},
                ["<C-j>"] = { "snippet_forward" },
                ["<C-k>"] = { "snippet_backward" },
                ["<C-s>"] = { "show_signature", "hide_signature" },
            },
            cmdline = {
                completion = {
                    menu = {
                        auto_show = true,
                    },
                },
            },
            appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight
                -- groups Useful for when your theme doesn't support blink.cmp
                -- Will be removed in a future release
                -- use_nvim_cmp_as_default = true,
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd
                -- Font' Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "normal",
            },
            completion = {
                menu = {
                    border = "single",
                    draw = {
                        components = {
                            -- customize the drawing of kind icons
                            kind_icon = {
                                text = function(ctx)
                                    -- default kind icon
                                    local icon = ctx.kind_icon
                                    -- if LSP source, check for color derived
                                    -- from documentation
                                    if ctx.item.source_name == "LSP" then
                                        local color_item = require(
                                            "nvim-highlight-colors"
                                        ).format(
                                            ctx.item.documentation,
                                            { kind = ctx.kind }
                                        )
                                        if
                                            color_item
                                            and color_item.abbr ~= ""
                                        then
                                            icon = color_item.abbr
                                        end
                                    end
                                    return icon .. ctx.icon_gap
                                end,
                                highlight = function(ctx)
                                    -- default highlight group
                                    local highlight = "BlinkCmpKind" .. ctx.kind
                                    -- if LSP source, check for color derived
                                    -- from documentation
                                    if ctx.item.source_name == "LSP" then
                                        local color_item = require(
                                            "nvim-highlight-colors"
                                        ).format(
                                            ctx.item.documentation,
                                            { kind = ctx.kind }
                                        )
                                        if
                                            color_item
                                            and color_item.abbr_hl_group
                                        then
                                            highlight = color_item.abbr_hl_group
                                        end
                                    end
                                    return highlight
                                end,
                            },
                        },
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 300,
                    window = {
                        border = "single",
                        scrollbar = false, -- Until crashes are fixed
                    },
                },
                ghost_text = { show_with_menu = false },
            },

            -- Default list of enabled providers defined so that you can extend
            -- it elsewhere in your config, without redefining it, due
            -- to `opts_extend`
            sources = {
                default = function()
                    local success, node = pcall(vim.treesitter.get_node)

                    if success and node then
                        if
                            vim.tbl_contains(
                                { "comment", "line_comment", "block_comment" },
                                node:type()
                            )
                        then
                            return { "buffer" }
                        end
                    end

                    return { "lsp", "snippets", "path", "buffer" }
                end,
            },
            signature = {
                enabled = true,
                window = { border = "single" },
            },

            -- Blink.cmp uses a Rust fuzzy matcher by default for typo
            -- resistance and significantly better performance
            -- You may use a lua implementation instead by using
            -- `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using
            -- `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = {
                implementation = "prefer_rust_with_warning",
                sorts = {
                    "score",
                    "sort_text",
                },
            },
        },
        config = function(_, opts)
            require("blink.cmp").setup(opts)
        end,
        opts_extend = { "sources.default" },
    },
}
