return {
    {
        -- Autocompletion
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = "lazydev",
                group_index = 0,
            })
        end,
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            {
                "L3MON4D3/LuaSnip",
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
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-path",
        },
        config = function()
            -- See `:help cmp`
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            require("luasnip.config").setup({
                update_events = { "TextChanged", "TextChangedI" },
            })

            require("luasnip.loaders.from_lua").lazy_load({
                paths = { vim.fn.stdpath("config") .. "/lua/renato/snippets" },
            })

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                completion = { completeopt = "menu,menuone,noinsert" },

                formatting = {
                    format = function(entry, item)
                        local widths = {
                            abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr
                                or 40,
                            menu = vim.g.cmp_widths and vim.g.cmp_widths.menu
                                or 30,
                        }

                        for key, width in pairs(widths) do
                            if
                                item[key]
                                and vim.fn.strdisplaywidth(item[key])
                                    > width
                            then
                                item[key] = vim.fn.strcharpart(
                                    item[key],
                                    0,
                                    width - 1
                                ) .. "..."
                            end
                        end

                        return item
                    end,
                },

                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },

                -- For an understanding of why these mappings were
                -- chosen, you will need to read `:help ins-completion`
                --
                -- No, but seriously. Please read `:help ins-completion`, it is really good!
                mapping = cmp.mapping.preset.insert({
                    -- Select the [n]ext item
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    -- Select the [p]revious item
                    ["<C-p>"] = cmp.mapping.select_prev_item(),

                    -- Scroll the documentation window [b]ack / [f]orward
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    -- Accept ([y]es) the completion.
                    --  This will auto-import if your LSP supports it.
                    --  This will expand snippets if the LSP sent a snippet.
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),

                    -- Manually trigger a completion from nvim-cmp.
                    --  Generally you don't need this, because nvim-cmp will display
                    --  completions whenever it has completion options available.
                    ["<C-x><C-o>"] = cmp.mapping.complete({}),

                    -- Think of <c-j> as moving to the right of your snippet expansion.
                    --  So if you have a snippet that's like:
                    --  function $name($args)
                    --    $body
                    --  end
                    --
                    -- <c-j> will move you to the right of each of the expansion locations.
                    -- <c-k> is similar, except moving you backwards.
                    ["<C-j>"] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { "i", "s" }),
                    ["<C-k>"] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { "i", "s" }),
                    ["<C-l>"] = cmp.mapping(function()
                        if luasnip.choice_active() then
                            luasnip.change_choice(1)
                        end
                    end, { "i", "s" }),
                    ["<C-s>"] = cmp.mapping(function()
                        if luasnip.choice_active() then
                            luasnip.change_choice(-1)
                        end
                    end, { "i", "s" }),

                    -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
                    --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
                }),
                sources = {
                    { name = "luasnip" },
                    { name = "nvim_lsp" },
                    { name = "path" },
                    { name = "buffer" },
                },
            })

            -- DB completion
            cmp.setup.filetype({ "sql" }, {
                sources = {
                    { name = "vim-dadbod-completion" },
                    { name = "buffer" },
                },
            })

            cmp.setup.filetype({ "css", "html", "javascript" }, {
                formatting = {
                    format = require("nvim-highlight-colors").format,
                },
            })

            -- `:` cmdline setup.
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    {
                        name = "cmdline",
                        option = {
                            ignore_cmds = { "Man", "!" },
                        },
                    },
                }),
            })

            -- `/` cmdline setup.
            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })
        end,
    },
}
