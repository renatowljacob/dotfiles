-- Icons
do
    if vim.g.have_nerd_font then
        require("nvim-web-devicons").setup()
    end
end

-- UI2
do
    require("vim._core.ui2").enable({
        enable = true,
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
                                return ctx.kind_icon .. ctx.icon_gap
                            end,
                            highlight = function(ctx)
                                local highlight = "BlinkCmpKind" .. ctx.kind
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
        sources = {
            default = function()
                if vim.bo.filetype == "dap-repl" then
                    return { "dap" }
                end

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
                end

                return { "lsp", "snippets", "path", "buffer" }
            end,
            providers = {
                dap = {
                    name = "DAP",
                    module = "blink-dap",
                },
            },
        },
        signature = {
            enabled = true,
            window = { border = "single" },
        },
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

    --   Toggle bracket coloring
    vim.keymap.set("n", "<leader>dc", function()
        require("rainbow-delimiters").toggle(0)
    end, { desc = "Toggle Bracket Coloring" })
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

    --   Toggle highlight color
    vim.keymap.set(
        "n",
        "<leader>dh",
        "<cmd>HighlightColors Toggle<CR>",
        { desc = "Toggle Highlight Colors" }
    )
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

    vim.list_extend(ensure_installed, {
        -- Debuggers
        "cpptools",
        -- Formatters
        "clang-format",
        "shfmt",
        "stylua",
        -- Linters
        "shellcheck",
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

-- Formatter
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
            sh = { "shfmt" },
        },
        format_on_save = function(bufnr)
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
    local treesitter = require("nvim-treesitter")
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
    treesitter.install(filetypes)

    -- No specific parser for these, just start treesitter
    vim.list_extend(filetypes, {
        "javascriptreact",
        "typescriptreact",
        "sh",
    })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        callback = function(event)
            vim.treesitter.start(event.buf)
        end,
    })

    require("treesitter-context").setup({
        enable = true,
        multiline_threshold = 1,
    })
end

---@class DAP_State
---@field last_win number
local DAP_State = {}

-- DAP
do
    local dap = require("dap")
    local dapui = require("dapui")
    local dapvirt = require("nvim-dap-virtual-text")

    require("mason-nvim-dap").setup({
        automatic_installation = true,
        handlers = {},
        ensure_installed = {},
    })

    -- Dap UI setup
    dapui.setup({
        layouts = {
            {
                elements = {
                    {
                        id = "stacks",
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
                        id = "scopes",
                        size = 0.7,
                    },
                },
                position = "left",
                size = 60,
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

    -- Bruh, these virtual texts do not go away
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
        dapvirt.enable()
    end
    dap.listeners.after.event_terminated["dapui_config"] = function()
        dapui.close()
        dapvirt.disable()
        dapvirt.refresh()
    end
    dap.listeners.after.event_exited["dapui_config"] =
        dap.listeners.after.event_terminated["dapui_config"]

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, "DapBreak", {
        link = "@module.builtin",
    })
    vim.api.nvim_set_hl(0, "DapStop", {
        link = "@comment.warning",
    })
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

    -- Custom function so that DAP scrolls without snatching my cursor in
    -- another window
    dap.defaults.fallback.switchbuf = function(bufnr, line, column)
        local wins =
            vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage())
        local wins_with_buf = {}
        for _, win in ipairs(wins) do
            if bufnr == vim.api.nvim_win_get_buf(win) then
                table.insert(wins_with_buf, win)
            end
        end

        if #wins_with_buf > 0 then
            DAP_State.last_win = math.min(unpack(wins_with_buf))
        end

        local win = DAP_State.last_win
        vim.api.nvim_win_set_buf(win, bufnr)
        vim.api.nvim_win_set_cursor(win, { line, column })
    end

    dap.repl.commands.custom_commands = {
        [".print"] = function(symbol)
            dap.repl.execute("-exec print " .. symbol)
        end,
        [".do"] = function(command)
            dap.repl.execute("-exec " .. command)
        end,
    }

    do
        ---@param name string
        ---@param type string
        ---@param opts? table
        local function dbg_config(name, type, opts)
            local config = {
                name = name .. ": Launch file",
                type = type,
                request = "launch",
                program = function()
                    local path = vim.fn.input(
                        "Path to executable: ",
                        vim.fn.getcwd() .. "/",
                        "file"
                    )
                    return (path and path ~= "") and path or dap.ABORT
                end,
                cwd = "${workspaceFolder}",
            }

            if opts ~= nil then
                config = vim.tbl_extend("keep", config, opts)
            end

            local config_args = vim.tbl_extend("force", config, {
                name = name .. ": Launch file with args",
                args = function()
                    return vim.fn.split(vim.fn.input("Arguments: "), " ", true)
                end,
            })

            return config, config_args
        end

        dap.configurations = {
            c = { dbg_config("GDB", "cppdbg") },
            cpp = dap.configurations.c,
            odin = dap.configurations.c,
            java = { dbg_config("JavaDAP", "java", { vmArgs = "-Xmx2g " }) },
            python = { dbg_config("debugpy", "python") },
        }
    end

    ---@param lhs string
    ---@param rhs function
    ---@param desc string
    ---@param modes? string[]
    local function map_dap(lhs, rhs, desc, modes)
        vim.keymap.set(modes or "n", lhs, rhs, { desc = "Inspect: " .. desc })
    end

    map_dap("<F1>", dap.continue, "Continue")
    map_dap("<F2>", dap.step_into, "Step into")
    map_dap("<F3>", dap.step_over, "Step over")
    map_dap("<F4>", dap.step_out, "Step out")
    map_dap("<F5>", dap.run_to_cursor, "Continue to cursor")
    map_dap("<F6>", dap.up, "Go up stackframe")
    map_dap("<F7>", dap.down, "Go down stackframe")
    map_dap("<F8>", dapui.toggle, "Toggle UI")
    map_dap("<F9>", dap.continue, "Start session")
    map_dap("<F10>", dap.restart, "Restart session")
    map_dap("<F11>", dap.run_last, "Restore last session")
    map_dap("<F12>", dap.terminate, "Terminate session")
    map_dap("<leader>it", dap.toggle_breakpoint, "Toggle breakpoint")
    map_dap("<leader>ib", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, "Set breakpoint")
    map_dap("<leader>ic", dap.clear_breakpoints, "Clear breakpoints")
    map_dap("<leader>ie", dapui.eval, "Eval expression", { "n", "v" })
    map_dap("<leader>ii", dapui.float_element, "Check element")
end

-- Which Key
do
    ---@param tbl table
    ---@param keymap string
    ---@param group string
    ---@param icon string|{icon: string, color: string}?
    local function append_table(tbl, keymap, group, icon)
        table.insert(tbl.spec, { keymap, group = group, icon = icon or nil })
        table.insert(tbl.spec, { keymap .. "_", hidden = true })
    end
    local opts = {
        delay = 300,
        preset = "helix",
        spec = {},
    }
    append_table(opts, "gr", "Code")
    append_table(opts, "<leader>b", "Buffer")
    append_table(opts, "<leader>c", "cd")
    append_table(opts, "<leader>d", "Document", "󰈔")
    append_table(opts, "<leader>f", "Dotbare")
    append_table(opts, "<leader>g", "Git")
    append_table(opts, "<leader>n", "Neovim", { icon = "", color = "green" })
    append_table(opts, "<leader>i", "Inspect", { icon = "󰃤", color = "red" })
    append_table(opts, "<leader>s", "Search")
    append_table(opts, "<leader>t", "Tab")
    require("which-key").setup(opts)
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

    ---@param lhs string
    ---@param code string?
    local map_bs = function(lhs, code)
        vim.keymap.set("i", lhs, function()
            return MiniPairs.bs(code)
        end, { expr = true, replace_keycodes = false })
    end

    map_bs("<C-h>", nil)
    map_bs("<C-w>", "\23")
    map_bs("<C-u>", "\21")

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
    local size = 0.9
    local input_height = 1
    local previewer_ratio = 0.65

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
                            width = size,
                            min_width = 120,
                            height = size,
                            {
                                box = "vertical",
                                border = "rounded",
                                title = "{title} {live} {flags}",
                                {
                                    win = "input",
                                    height = input_height,
                                    border = "bottom",
                                },
                                { win = "list", border = "none" },
                            },
                            {
                                win = "preview",
                                title = "{preview}",
                                border = "rounded",
                                width = previewer_ratio,
                            },
                        },
                    },
                    vertical = {
                        layout = {
                            backdrop = false,
                            width = size,
                            min_width = 80,
                            height = size,
                            min_height = 30,
                            box = "vertical",
                            border = "rounded",
                            title = "{title} {live} {flags}",
                            title_pos = "center",
                            {
                                win = "input",
                                height = input_height,
                                border = "bottom",
                            },
                            { win = "list", border = "none" },
                            {
                                win = "preview",
                                title = "{preview}",
                                height = previewer_ratio,
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

    ---@param lhs string
    ---@param rhs function
    ---@param desc string
    ---@param modes? string[]
    local function map_snacks(lhs, rhs, desc, modes)
        vim.keymap.set(modes or "n", lhs, rhs, { desc = desc })
    end

    local picker = Snacks.picker
    map_snacks("<leader><leader>", picker.resume, "Resume search")
    map_snacks("<leader>/", picker.lines, "Fuzzy search current buffer")
    map_snacks("<leader>sb", picker.buffers, "Find existing buffers")
    map_snacks("<leader>s.", picker.recent, "Search recent files")
    map_snacks("<leader>s/", picker.grep_buffers, "Live grep open files")
    map_snacks("<leader>sg", picker.grep, "Grep files")
    map_snacks("<leader>sw", picker.grep_word, "Grep word", { "n", "x", "v" })
    map_snacks("<leader>sf", picker.files, "Search files")
    map_snacks("<leader>sd", picker.diagnostics, "Search diagnostics")
    map_snacks("<leader>sh", picker.help, "Search help docs")
    map_snacks("<leader>sm", picker.man, "Search man pages")
    map_snacks("<leader>sn", function()
        picker.files({
            dirs = { vim.fn.stdpath("config") },
        })
    end, "Search neovim files")
    map_snacks("<leader>sH", picker.highlights, "Search highlights")
    map_snacks("<leader>sk", picker.keymaps, "Search keymaps")
    map_snacks("<leader>sN", picker.notifications, "Search notifications")
    map_snacks("<leader>ss", picker.pickers, "Select picker")
    map_snacks("<leader>su", function()
        picker.undo({
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
    end, "Search undo tree")
    map_snacks("grN", Snacks.rename.rename_file, "Rename file")
end

---Toggle between Snacks terminals

---@class Terminal_State
---@field idx number Terminal index
---@field keys string[] Mapped keys
local Terminal_State = {
    idx = 1,
    keys = {
        "H",
        "J",
        "K",
        "L",
    },
}
do
    ---@param idx number?
    local function toggle_nth_terminal(idx)
        Terminal_State.idx = idx or Terminal_State.idx
        local opts = {
            auto_insert = false,
            count = Terminal_State.idx,
            win = {
                wo = {
                    winbar = "Terminal "
                        .. Terminal_State.keys[Terminal_State.idx],
                },
            },
        }

        Snacks.terminal.toggle(nil, opts)
    end

    ---@param lhs string
    ---@param idx number?
    local function map_terminal(lhs, idx)
        vim.keymap.set("n", lhs, function()
            toggle_nth_terminal(idx)
        end, {
            desc = idx and "Toggle terminal " .. idx or "Toggle terminal",
        })
    end

    map_terminal("<C-t><C-t>")
    map_terminal("<C-t><C-h>", 1)
    map_terminal("<C-t><C-j>", 2)
    map_terminal("<C-t><C-k>", 3)
    map_terminal("<C-t><C-l>", 4)
end

-- Dotbare as dotfiles/git fuzzy client
do
    ---@param args string|string[]
    ---@param is_git boolean? Use as generic git client (default false)
    local function dotbare(args, is_git)
        args = args or {}
        is_git = is_git or false

        local command = { "dotbare" }
        if is_git then
            table.insert(command, "--git")
        end
        command = vim.iter({ command, args }):flatten():totable()

        local bufnr = vim.api.nvim_create_buf(false, true)
        vim.bo[bufnr].bufhidden = "wipe"
        vim.bo[bufnr].modifiable = false

        local ratio = 0.85
        local height = math.ceil(vim.o.lines * ratio)
        local width = math.ceil(vim.o.columns * ratio)
        local window = vim.api.nvim_open_win(bufnr, true, {
            relative = "editor",
            height = height,
            width = width,
            border = "solid",
            col = math.ceil((vim.o.columns - width) / 2),
            row = math.ceil((vim.o.lines - height) / 2),
        })
        vim.api.nvim_set_current_win(window)

        vim.fn.jobstart(command, {
            cwd = is_git and vim.fn.getcwd() or vim.env.HOME,
            on_exit = function(_, status, _)
                if vim.api.nvim_win_is_valid(window) then
                    vim.api.nvim_win_close(window, true)
                end

                -- If no files were selected or any other error
                if args == "fstat" or status ~= 0 then
                    return nil
                end

                -- list_bufs() includes unlisted buffers
                local buflist = vim.api.nvim_list_bufs()
                local lastbuf = buflist[#buflist]
                if vim.api.nvim_buf_is_valid(lastbuf) then
                    vim.api.nvim_set_current_buf(lastbuf)
                end
            end,
            term = true,
        })

        -- The buffer is a terminal but you want <Esc> to quit the window
        vim.keymap.del("t", "<Esc><Esc>", {
            buffer = bufnr,
        })

        vim.cmd.startinsert()
    end

    ---@param cmd string
    ---@param lhs string
    ---@param desc string
    ---@param is_git boolean?
    local function map_git(cmd, lhs, desc, is_git)
        vim.keymap.set("n", lhs, function()
            dotbare(cmd, is_git or false)
        end, { desc = desc })
    end

    map_git("fadd", "<leader>fa", "Git add")
    map_git("fedit", "<leader>ff", "Search tracked files")
    map_git("fgrep", "<leader>fg", "Grep tracked files")
    map_git("flog", "<leader>fl", "Git log")
    map_git("fstash", "<leader>fS", "Git stash")
    map_git("fstat", "<leader>fs", "Git status")

    map_git("fadd", "<leader>ga", "Git add", true)
    map_git("fedit", "<leader>gf", "Search tracked files", true)
    map_git("fgrep", "<leader>gg", "Grep tracked files", true)
    map_git("flog", "<leader>gl", "Git log", true)
    map_git("fstash", "<leader>gS", "Git stash", true)
    map_git("fstat", "<leader>gs", "Git status", true)
end
