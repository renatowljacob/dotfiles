-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`

local MyApi = require("renato.core.myapi")

vim.api.nvim_create_autocmd("BufWritePost", {
    desc = "Update rainbow delimiters highlighting",
    group = vim.api.nvim_create_augroup(
        "update-rainbow-delimiters",
        { clear = true }
    ),
    callback = function()
        local plugins = require("lazy").plugins()

        for _, plugin in ipairs(plugins) do
            if plugin.name == "rainbow-delimiters.nvim" and plugin._.loaded then
                local rainbow_delimiters = require("rainbow-delimiters")

                rainbow_delimiters.disable(0)
                rainbow_delimiters.enable(0)
            end
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "Quickfix list navigation keymaps",
    group = vim.api.nvim_create_augroup(
        "set-quickfix-keymaps",
        { clear = true }
    ),
    pattern = "qf",
    callback = function()
        local opts = { silent = true }
        local buffer = MyApi.buf

        vim.keymap.set("n", "]q", function()
            vim.cmd("silent! lnext | silent! cn")

            buffer.highlight_line(buffer.get_qfline())
        end, opts)
        vim.keymap.set("n", "[q", function()
            vim.cmd("silent! lprev | silent! cp")

            buffer.highlight_line(buffer.get_qfline())
        end, opts)
    end,
})

--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup(
        "kickstart-lsp-attach",
        { clear = true }
    ),
    callback = function(event)
        -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc)
            vim.keymap.set(
                "n",
                keys,
                func,
                { buffer = event.buf, desc = "LSP: " .. desc }
            )
        end

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map("grd", require("snacks.picker").lsp_definitions, "Goto Definition")

        -- Find references for the word under your cursor.
        map("grr", require("snacks.picker").lsp_references, "Goto References")

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map(
            "gri",
            require("snacks.picker").lsp_implementations,
            "Goto Implementation"
        )

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map(
            "grt",
            require("snacks.picker").lsp_type_definitions,
            "Type Definition"
        )

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map(
            "grO",
            require("snacks.picker").lsp_workspace_symbols,
            "Workspace Symbols"
        )

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map("grn", vim.lsp.buf.rename, "Rename")

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map("gra", vim.lsp.buf.code_action, "Code Action")

        -- Opens a popup that displays documentation about the word under your cursor
        --  See `:help K` for why this keymap.
        -- map("K", vim.lsp.buf.hover, "Hover Documentation")

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map("grD", vim.lsp.buf.declaration, "Goto Declaration")

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if
            client
            and client:supports_method(
                vim.lsp.protocol.Methods.textDocument_documentHighlight
            )
        then
            local highlight_augroup = vim.api.nvim_create_augroup(
                "kickstart-lsp-highlight",
                { clear = false }
            )
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
                group = vim.api.nvim_create_augroup(
                    "kickstart-lsp-detach",
                    { clear = true }
                ),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds({
                        group = "kickstart-lsp-highlight",
                        buffer = event2.buf,
                    })
                end,
            })
        end

        -- The following autocommand is used to enable inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if
            client
            and client:supports_method(
                vim.lsp.protocol.Methods.textDocument_inlayHint
            )
        then
            map("grI", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
            end, "Inlay Hints")
        end
    end,
})

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
    desc = "Lsp Progress Notification",
    group = vim.api.nvim_create_augroup("lsp-notification", { clear = true }),
    ---@param event {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local value = event.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
        if not client or type(value) ~= "table" then
            return
        end
        local p = progress[client.id]

        for i = 1, #p + 1 do
            if i == #p + 1 or p[i].token == event.data.params.token then
                p[i] = {
                    token = event.data.params.token,
                    msg = ("[%3d%%] %s%s"):format(
                        value.kind == "end" and 100 or value.percentage or 100,
                        value.title or "",
                        value.message and (" **%s**"):format(value.message)
                            or ""
                    ),
                    done = value.kind == "end",
                }
                break
            end
        end

        local msg = {} ---@type string[]
        progress[client.id] = vim.tbl_filter(function(v)
            return table.insert(msg, v.msg) or not v.done
        end, p)

        local spinner = {
            "⠋",
            "⠙",
            "⠹",
            "⠸",
            "⠼",
            "⠴",
            "⠦",
            "⠧",
            "⠇",
            "⠏",
        }
        ---@diagnostic disable-next-line: param-type-mismatch
        vim.notify(table.concat(msg, "\n"), "info", {
            id = "lsp_progress",
            title = client.name,
            opts = function(notif)
                notif.icon = #progress[client.id] == 0 and " "
                    or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
        })
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    desc = "Set local options for terminal buffer",
    group = vim.api.nvim_create_augroup("set-terminal-opts", { clear = true }),
    callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local winid = vim.api.nvim_get_current_win()
        local current_win_opt = vim.wo[winid][0]

        current_win_opt.number = false
        current_win_opt.relativenumber = false
        current_win_opt.signcolumn = "no"

        if vim.bo[bufnr].filetype ~= "snacks_terminal" then
            current_win_opt.winbar = ""
        end

        vim.keymap.set(
            "t",
            "<Esc><Esc>",
            "<C-\\><C-n>",
            { buffer = bufnr, desc = "Exit terminal mode" }
        )
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup(
        "kickstart-highlight-yank",
        { clear = true }
    ),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- I just get a blank screen until I type <C-C>, dunno why :P
vim.api.nvim_create_autocmd("VimEnter", {
    desc = "Suckless when it sucks",
    group = vim.api.nvim_create_augroup("suckless-when", { clear = true }),
    callback = function()
        if vim.env.TERM ~= "st-256color" or vim.env.TERM ~= "st" then
            return
        end

        vim.api.nvim_input("<C-C>")
    end,
})

vim.api.nvim_create_autocmd("VimResized", {
    desc = "Resize splits in window resize",
    group = vim.api.nvim_create_augroup("resize-splits", { clear = true }),
    callback = function()
        local current_tab = vim.api.nvim_get_current_tabpage()

        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
})
