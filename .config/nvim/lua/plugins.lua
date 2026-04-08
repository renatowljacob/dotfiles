-- Icons
do
    if vim.g.have_nerd_font then
        require("nvim-web-devicons").setup()
    end
end

-- UI2
do
    require("vim._core.ui2").enable({
        enable = true, -- Whether to enable or disable the UI.
        msg = { -- Options related to the message module.
            ---@type 'cmd'|'msg' Default message target, either in the
            ---cmdline or in a separate ephemeral message window.
            ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
            ---or table mapping |ui-messages| kinds and triggers to a target.
            targets = "cmd",
            cmd = { -- Options related to messages in the cmdline window.
                height = 0.5, -- Maximum height while expanded for messages beyond 'cmdheight'.
            },
            dialog = { -- Options related to dialog window.
                height = 0.5, -- Maximum height.
            },
            msg = { -- Options related to msg window.
                height = 0.5, -- Maximum height.
                timeout = 4000, -- Time a message is visible in the message window.
            },
            pager = { -- Options related to message window.
                height = 1, -- Maximum height.
            },
        },
    })
end

-- Blink.cmp
do
    require("blink.cmp").setup({
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

                                -- if ctx.item.source_name == "LSP" then
                                --     local color_item =
                                --         require("nvim-highlight-colors").format(
                                --             ctx.item.documentation,
                                --             { kind = ctx.kind }
                                --         )
                                --     if color_item and color_item.abbr ~= "" then
                                --         icon = color_item.abbr
                                --     end
                                -- end
                                return icon .. ctx.icon_gap
                            end,
                            highlight = function(ctx)
                                -- default highlight group
                                local highlight = "BlinkCmpKind" .. ctx.kind
                                -- if LSP source, check for color derived
                                -- from documentation
                                if ctx.item.source_name == "LSP" then
                                    local color_item =
                                        require("nvim-highlight-colors").format(
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
                    scrollbar = true,
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
                local sources = { "lsp", "snippets", "path", "buffer" }

                if success and node then
                    if
                        vim.tbl_contains(
                            { "comment", "line_comment", "block_comment" },
                            node:type()
                        )
                    then
                        sources = { "buffer" }
                    end
                end

                return sources
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
    })
end

-- Tokyo Night
do
    require("tokyonight").setup({
        style = "storm",
        transparent = true,
        styles = {
            floats = "transparent",
            sidebars = "transparent",
        },
    })
    vim.cmd.colorscheme("tokyonight")

    -- You can configure highlights by doing something like:
    vim.cmd.hi("DapStoppedLine guibg=#1D202F")
    vim.cmd.hi("DebugPC guibg=bg")
    vim.cmd.hi("BlinkCmpMenu guibg=bg")
    vim.cmd.hi("LineNr gui=bold")
end

-- Rainbow Delimiters
do
    require("rainbow-delimiters")
    vim.g.rainbow_delimiters = {
        strategy = {
            [""] = "rainbow-delimiters.strategy.global",
        },
        query = {
            [""] = "rainbow-delimiters",
            lua = "rainbow-blocks",
        },
        priority = {
            [""] = 110,
            lua = 210,
        },
        highlight = {
            "RainbowDelimiterRed",
            "RainbowDelimiterViolet",
            "RainbowDelimiterCyan",
        },
    }
end

-- Gitsigns
do
    require("gitsigns").setup({
        signs = {
            add = { text = "+" },
            change = { text = "~" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
        },
    })
end

-- Sentiment
do
    require("sentiment").setup({
        delay = 30,
        limit = 100,
        pairs = {
            { "(", ")" },
            { "{", "}" },
            { "[", "]" },
        },
    })

    vim.g.loaded_matchparen = 1
    vim.cmd.hi("MatchParen guifg=none guibg=#3b4261")
end

-- Highlight Colors
do
    require("nvim-highlight-colors").setup({
        render = "background",
        virtual_symbol = "■",
        enable_named_colors = vim.bo.filetype == "css",
        enable_hsl_colors = vim.bo.filetype == "css",
        enable_rgb_colors = vim.bo.filetype == "css",
        enable_tailwind = vim.bo.filetype == "css",
        exclude_buftypes = { "nofile" },
    })
end

-- lspconfig
do
    require("mason").setup({})
    require("lazydev").setup({
        library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
    })

    local ensure_installed = {}

    for server, _ in vim.fs.dir(vim.env.XDG_CONFIG_HOME .. "/nvim/after/lsp") do
        local server_name = vim.fn.fnamemodify(server, ":t:r")
        if server_name ~= "clangd" then
            table.insert(ensure_installed, server_name)
        end
    end

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    vim.list_extend(ensure_installed, {
        -- Debuggers
        "cpptools", -- GDB setup
        "java-debug-adapter",
        -- Formatters
        "clang-format",
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
end

-- Conform
do
    require("conform").setup({
        notify_on_error = false,
        notify_no_formatters = false,
        default_format_opts = {
            stop_after_first = true,
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
                    "--keep-padding",
                    "--space-redirects",
                },
            },
        },
        formatters_by_ft = {
            bash = { "shfmt" },
            c = { "clang-format" },
            cpp = { "clang-format" },
            css = { "biome", "prettier" },
            html = { "biome", "prettier" },
            lua = { "stylua" },
            python = { "ruff" },
            sh = { "shfmt" },
        },
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
    })
end

-- Linting
do
    local lint = require("lint")
    lint.linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
            if vim.opt_local.modifiable:get() then
                lint.try_lint()
            end
        end,
    })
end

-- Treesitter
do
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

    require("treesitter-context").setup({
        enable = true,
        multiline_threshold = 1,
    })
end

-- DAP
do
    local dap = require("dap")
    local dapui = require("dapui")
    local dapvirt = require("nvim-dap-virtual-text")
    local colors = require("tokyonight.colors").setup()

    require("mason-nvim-dap").setup({
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {},

        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
            -- Update this to ensure that you have the debuggers for the langs you want
        },
    })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup({
        layouts = {
            {
                elements = {
                    {
                        id = "scopes",
                        size = 0.1,
                    },
                    {
                        id = "breakpoints",
                        size = 0.1,
                    },
                    {
                        id = "watches",
                        size = 0.1,
                    },
                    {
                        id = "stacks",
                        size = 0.7,
                    },
                },
                position = "left",
                size = 40,
            },
            {
                elements = {
                    {
                        id = "repl",
                        size = 0.5,
                    },
                    {
                        id = "console",
                        size = 0.5,
                    },
                },
                position = "bottom",
                size = 10,
            },
        },
    })

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, "DapBreak", { fg = colors.red })
    vim.api.nvim_set_hl(0, "DapStop", { fg = colors.yellow })
    local breakpoint_icons = vim.g.have_nerd_font
            and {
                Breakpoint = "",
                BreakpointCondition = "",
                BreakpointRejected = "",
                LogPoint = "",
                Stopped = "",
            }
        or {
            Breakpoint = "●",
            BreakpointCondition = "⊜",
            BreakpointRejected = "⊘",
            LogPoint = "◆",
            Stopped = "⭔",
        }
    for type, icon in pairs(breakpoint_icons) do
        local tp = "Dap" .. type
        local hl = (type == "Stopped") and "DapStop" or "DapBreak"
        vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    -- Bruh, these virtual texts do not go away
    dap.listeners.after.event_initialized["dapui_config"] = function()
        vim.o.switchbuf = "uselast"
        dapui.open()
        dapvirt.enable()
    end
    dap.listeners.after.event_terminated["dapui_config"] = function()
        vim.o.switchbuf = "useopen"
        dapui.close()
        dapvirt.disable()
        dapvirt.refresh()
    end
    dap.listeners.after.event_exited["dapui_config"] = function()
        vim.o.switchbuf = "useopen"
        dapui.close()
        dapvirt.disable()
        dapvirt.refresh()
    end

    -- GDB setup
    dap.configurations.c = {
        {
            name = "Launch file",
            type = "cppdbg",
            request = "launch",
            program = function()
                return vim.fn.input(
                    "Path to executable: ",
                    vim.fn.getcwd() .. "/",
                    "file"
                )
            end,
            cwd = "${workspaceFolder}",
            stopAtEntry = true,
        },
        {
            name = "Launch file with arguments",
            type = "cppdbg",
            request = "launch",
            program = function()
                return vim.fn.input(
                    "Path to executable: ",
                    vim.fn.getcwd() .. "/",
                    "file"
                )
            end,
            cwd = "${workspaceFolder}",
            args = function()
                return vim.fn.split(vim.fn.input("Arguments: "), " ", true)
            end,
        },
    }
    dap.configurations.cpp = dap.configurations.c
    dap.configurations.odin = dap.configurations.c

    dap.configurations.java = {
        {
            name = "Run Debugger (2GB)",
            type = "java",
            request = "launch",
            vmArgs = "" .. "-Xmx2g ",
        },
    }

    dap.configurations.python = {
        {
            name = "Launch file",
            type = "python",
            request = "launch",
            program = function()
                return vim.fn.input(
                    "Path to script: ",
                    vim.fn.getcwd() .. "/",
                    "file"
                )
            end,
        },
        {
            name = "Launch file with arguments",
            type = "python",
            request = "launch",
            program = function()
                return vim.fn.input(
                    "Path to script: ",
                    vim.fn.getcwd() .. "/",
                    "file"
                )
            end,
            cwd = "${workspaceFolder}",
            args = function()
                return vim.fn.split(vim.fn.input("Arguments: "), " ", true)
            end,
        },
    }

    vim.keymap.set("n", "<F1>", function()
        dap.step_into()
    end, { desc = "Debug: Step into" })

    vim.keymap.set("n", "<F2>", function()
        dap.step_over()
    end, { desc = "Debug: Step over" })

    vim.keymap.set("n", "<F3>", function()
        dap.step_out()
    end, { desc = "Debug: Step out" })

    vim.keymap.set("n", "<F4>", function()
        dap.restart()
    end, { desc = "Debug: Restart" })

    vim.keymap.set("n", "<F5>", function()
        dap.step_into()
    end, { desc = "Debug: Step into" })

    vim.keymap.set("n", "<F6>", function()
        dap.run_last()
    end, { desc = "Debug: Run last session" })

    vim.keymap.set("n", "<F7>", function()
        dapui.toggle()
    end, { desc = "Debug: Toggle UI" })

    vim.keymap.set("n", "<F8>", function()
        dap.terminate()
    end, { desc = "Debug: Terminate" })

    vim.keymap.set("n", "<leader>tt", function()
        dap.toggle_breakpoint()
    end, { desc = "Debug: Toggle breakpoint" })

    vim.keymap.set("n", "<leader>tb", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Debug: Set breakpoint" })

    vim.keymap.set("n", "<leader>tc", function()
        dap.clear_breakpoints()
    end, { desc = "Debug: Clear breakpoints" })

    vim.keymap.set("n", "<leader>te", function()
        dapui.eval()
    end, { desc = "Debug: Eval expression" })

    vim.keymap.set("n", "<leader>ti", function()
        dapui.float_element()
    end, { desc = "Debug: Inspect element" })
end

-- Which Key
do
    require("which-key").setup({
        delay = 300,
        preset = "helix",
        spec = {
            { "gr", group = "Code" },
            { "gr_", hidden = true },
            { "<leader>d", group = "Document", icon = "󰈔" },
            { "<leader>d_", hidden = true },
            { "<leader>g", group = "Git" },
            { "<leader>g_", hidden = true },
            { "<leader>h", group = "Harpoon", icon = "󱡀" },
            { "<leader>h_", hidden = true },
            {
                "<leader>l",
                group = "List Files",
                icon = {
                    icon = "",
                    color = "blue",
                },
            },
            { "<leader>l_", hidden = true },
            {
                "<leader>n",
                group = "Neovim",
                icon = {
                    icon = "",
                    color = "green",
                },
            },
            { "<leader>n_", hidden = true },
            {
                "<leader>o",
                group = "Operations",
                icon = {
                    icon = "󰾋",
                    color = "purple",
                },
            },
            { "<leader>o_", hidden = true },
            { "<leader>p", group = "Project" },
            { "<leader>p_", hidden = true },
            { "<leader>s", group = "Search" },
            { "<leader>s_", hidden = true },
            {
                "<leader>t",
                group = "Testing",
                icon = {
                    icon = "󰃤",
                    color = "red",
                },
            },
            { "<leader>t_", hidden = true },
        },
    })
end

-- Quicker
do
    require("quicker").setup({})
end

-- Mini.nvim
do
    require("mini.pairs").setup()
    require("mini.splitjoin").setup()
    require("mini.tabline").setup()
    require("mini.surround").setup()

    local map_bs = function(lhs, rhs)
        vim.keymap.set("i", lhs, rhs, { expr = true, replace_keycodes = false })
    end

    map_bs("<C-h>", function()
        return MiniPairs.bs()
    end)
    map_bs("<C-w>", function()
        return MiniPairs.bs("\23")
    end)
    map_bs("<C-u>", function()
        return MiniPairs.bs("\21")
    end)

    local statusline = require("mini.statusline")
    statusline.setup({
        use_icons = vim.g.have_nerd_font,
    })
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
        return "%2l:%-2v"
    end
end

-- Snacks.nvim
do
    require("snacks").setup({
        bufdelete = {
            enabled = true,
        },
        notifier = {
            style = "fancy",
        },
        picker = {
            enabled = true,
            layout = function()
                local layout = {
                    horizontal = {
                        layout = {
                            box = "horizontal",
                            width = 0.9,
                            min_width = 120,
                            height = 0.9,
                            {
                                box = "vertical",
                                border = "rounded",
                                title = "{title} {live} {flags}",
                                {
                                    win = "input",
                                    height = 1,
                                    border = "bottom",
                                },
                                { win = "list", border = "none" },
                            },
                            {
                                win = "preview",
                                title = "{preview}",
                                border = "rounded",
                                width = 0.65,
                            },
                        },
                    },
                    vertical = {
                        layout = {
                            backdrop = false,
                            width = 0.9,
                            min_width = 80,
                            height = 0.9,
                            min_height = 30,
                            box = "vertical",
                            border = "rounded",
                            title = "{title} {live} {flags}",
                            title_pos = "center",
                            {
                                win = "input",
                                height = 1,
                                border = "bottom",
                            },
                            { win = "list", border = "none" },
                            {
                                win = "preview",
                                title = "{preview}",
                                height = 0.65,
                                border = "top",
                            },
                        },
                    },
                }

                return vim.o.columns >= 160 and layout.horizontal
                    or layout.vertical
            end,
            win = {
                input = {
                    keys = {
                        ["<C-CR>"] = { "edit_vsplit", mode = { "i", "n" } },
                        ["<S-CR>"] = { "edit_split", mode = { "i", "n" } },
                    },
                },
                list = {
                    keys = {
                        ["<C-CR>"] = { "edit_vsplit", mode = { "i", "n" } },
                        ["<S-CR>"] = { "edit_split", mode = { "i", "n" } },
                    },
                },
            },
        },
        terminal = {
            enabled = true,
        },
    })
    vim.keymap.set("n", "<leader><leader>", function()
        Snacks.picker.buffers()
    end, { desc = "Find existing buffers" })

    vim.keymap.set("n", "<leader>s.", function()
        Snacks.picker.recent()
    end, { desc = 'Search Recent Files ("." for repeat)' })

    vim.keymap.set("n", "<leader>/", function()
        Snacks.picker.lines()
    end, { desc = "Fuzzily search in current buffer" })

    vim.keymap.set("n", "<leader>s/", function()
        Snacks.picker.grep_buffers()
    end, { desc = "Live Grep in Open Files" })

    vim.keymap.set("n", "<leader>sd", function()
        Snacks.picker.diagnostics()
    end, { desc = "Search Diagnostics" })

    vim.keymap.set("n", "<leader>sf", function()
        Snacks.picker.files()
    end, { desc = "Search Files" })

    vim.keymap.set("n", "<leader>sg", function()
        Snacks.picker.grep()
    end, { desc = "Search by Grep" })

    vim.keymap.set("n", "<leader>sh", function()
        Snacks.picker.help()
    end, { desc = "Search Help" })

    vim.keymap.set("n", "<leader>sH", function()
        Snacks.picker.highlights()
    end, { desc = "Search Highlights" })

    vim.keymap.set("n", "<leader>sk", function()
        Snacks.picker.keymaps()
    end, { desc = "Search Keymaps" })

    vim.keymap.set("n", "<leader>sm", function()
        Snacks.picker.man()
    end, { desc = "Search Man Pages" })

    vim.keymap.set("n", "<leader>sn", function()
        Snacks.picker.files({
            dirs = { vim.fn.stdpath("config") },
        })
    end, { desc = "Search Neovim files" })

    vim.keymap.set("n", "<leader>sp", function()
        Snacks.picker.files({ rtp = true })
    end, { desc = "Search Plugins" })

    vim.keymap.set("n", "<leader>sN", function()
        Snacks.picker.notifications()
    end, { desc = "Search Notifications" })

    vim.keymap.set("n", "<leader>ss", function()
        Snacks.picker.pickers()
    end, { desc = "Select Picker" })

    vim.keymap.set("n", "<leader>sr", function()
        Snacks.picker.resume()
    end, { desc = "Resume Search" })

    vim.keymap.set("n", "<leader>st", function()
        Snacks.picker.buffers({
            items = Snacks.terminal.list(),
            title = "Open Terminals",
        })
    end, { desc = "Search Terminal" })

    vim.keymap.set("n", "<leader>su", function()
        Snacks.picker.undo({
            win = {
                input = {
                    keys = {
                        ["<c-y>"] = {
                            "yank_add",
                            mode = { "n", "i" },
                        },
                        ["<M-y>"] = {
                            "yank_del",
                            mode = { "n", "i" },
                        },
                    },
                },
            },
        })
    end, { desc = "Search Undo Tree" })

    vim.keymap.set({ "n", "x", "v" }, "<leader>sw", function()
        Snacks.picker.grep_word()
    end, { desc = "Search For Word" })

    vim.keymap.set("n", "grN", function()
        Snacks.rename.rename_file()
    end, { desc = "Rename File" })
end
