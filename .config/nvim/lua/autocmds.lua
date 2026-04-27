-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`

local MyApi = require("myapi")

vim.api.nvim_create_autocmd("PackChanged", {
    desc = "Update treesitter and parsers",
    callback = function(event)
        local name, kind = event.data.spec.name, event.data.kind
        if name == "nvim-treesitter" and kind == "update" then
            if not event.data.active then
                vim.cmd.packadd("nvim-treesitter")
            end
            vim.cmd("TSUpdate")
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "Activate autotag functionality in HTML files",
    pattern = {
        "html",
        "javascript",
        "javascriptreact",
        "markdown",
        "php",
        "typescript",
        "typescriptreact",
        "vue",
        "xml",
    },
    callback = function()
        require("nvim-ts-autotag").setup()
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
        local function highlight_line(bufnr, lnum)
            local higroup = "IncSearch"
            local namespace =
                vim.api.nvim_create_namespace("highlight_quickfix")
            local timeout = 150
            local winid = vim.fn.bufwinid(
                bufnr and bufnr or vim.api.nvim_get_current_buf()
            )

            vim.api.nvim_win_set_hl_ns(winid, namespace)
            vim.hl.range(
                bufnr,
                namespace,
                higroup,
                { lnum, 0 },
                { lnum, -1 },
                { timeout = timeout }
            )
        end

        local function get_qfline()
            ---@type table
            local qflist = vim.fn.getqflist()
            local index = vim.fn.getqflist({ idx = 0 }).idx

            if vim.tbl_isempty(qflist) then
                qflist = vim.fn.getloclist(0)
                index = vim.fn.getloclist(0, { idx = 0 }).idx
            end

            if vim.tbl_isempty(qflist) then
                return nil
            end

            local line = qflist[index]
            local bufnr, lnum = line.bufnr, line.lnum - 1

            return bufnr, lnum
        end

        local function map_qf(lhs, direction)
            vim.keymap.set({ "n", "v" }, lhs, function()
                vim.cmd(
                    "silent! l"
                        .. direction
                        .. " | silent! c"
                        .. direction
                        .. " | silent! foldopen!"
                )
                highlight_line(get_qfline())
            end, { silent = true })
        end
        map_qf("]q", "next")
        map_qf("[q", "prev")
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup(
        "kickstart-lsp-attach",
        { clear = true }
    ),
    callback = function(event)
        local function map_lsp(keys, func, desc)
            vim.keymap.set(
                "n",
                keys,
                func,
                { buffer = event.buf, desc = "LSP: " .. desc }
            )
        end

        map_lsp(
            "grd",
            require("snacks.picker").lsp_definitions,
            "Goto Definition"
        )
        map_lsp(
            "grr",
            require("snacks.picker").lsp_references,
            "Goto References"
        )

        --  Useful when your language has ways of declaring types without an actual implementation.
        map_lsp(
            "gri",
            require("snacks.picker").lsp_implementations,
            "Goto Implementation"
        )
        map_lsp(
            "grt",
            require("snacks.picker").lsp_type_definitions,
            "Type Definition"
        )

        map_lsp("grs", function()
            local kinds = {
                -- "Array",
                -- "Boolean",
                "Class",
                "Constant",
                "Constructor",
                "Enum",
                "EnumMember",
                "Event",
                "Field",
                -- "File",
                "Function",
                "Interface",
                "Key",
                "Method",
                "Module",
                "Namespace",
                "Null",
                -- "Number",
                "Object",
                "Operator",
                "Package",
                "Property",
                "Struct",
                "TypeParameter",
                "Variable",
            }
            require("myapi").buf.document_symbols({
                filter = {
                    default = kinds,
                    lua = {
                        "Class",
                        "Constructor",
                        "Enum",
                        "Field",
                        "Function",
                        "Interface",
                        "Method",
                        "Module",
                        "Namespace",
                        -- "Package", -- remove package since luals uses it for control flow structures
                        "Property",
                        "Struct",
                        "Trait",
                        "Variable",
                    },
                },
            })
        end, "Document Symbols")
        map_lsp(
            "grw",
            require("snacks.picker").lsp_workspace_symbols,
            "Workspace Symbols"
        )

        map_lsp("grD", vim.lsp.buf.declaration, "Goto Declaration")

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if
            client
            and client:supports_method("textDocument/documentHighlight")
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

        if client and client:supports_method("textDocument/inlayHint") then
            map_lsp("grI", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
            end, "Inlay Hints")
        end
    end,
})

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
    desc = "Lsp progress Notification",
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
