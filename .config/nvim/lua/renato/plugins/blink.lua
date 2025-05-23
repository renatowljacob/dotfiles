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
            snippets = { preset = "luasnip" },

            -- Default list of enabled providers defined so that you can extend
            -- it elsewhere in your config, without redefining it, due
            -- to `opts_extend`
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
                    -- If in a declaration, expression or specifying a field,
                    -- sort LSP source first, otherwise sort snippets source
                    -- first by default.
                    function(a, b)
                        local success, node = pcall(vim.treesitter.get_node)
                        local source_priority = {
                            snippets = 4,
                            lsp = 3,
                            path = 2,
                            buffer = 1,
                        }
                        local node_types = {
                            "field",
                            "declaration",
                            "expression",
                            "attribute",
                            "member",
                            "declarator",
                        }

                        if not success or not node or not node:parent() then
                            source_priority.lsp = 3
                            source_priority.snippets = 4
                        else
                            local parent = node:parent():type()

                            for _, node_type in ipairs(node_types) do
                                -- If any node_types string is a substring of
                                -- parent
                                if parent:find(node_type) then
                                    source_priority.lsp = 4
                                    source_priority.snippets = 3
                                    break
                                end
                            end
                        end

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

            require("luasnip").setup({
                load_ft_func = require("luasnip.extras.filetype_functions").extend_load_ft({
                    h = { "c" },
                }),
            })

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
