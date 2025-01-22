-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`

local helpers = require("renato.core.helpers")

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup(
        "kickstart-highlight-yank",
        { clear = true }
    ),
    callback = function()
        vim.highlight.on_yank()
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

vim.api.nvim_create_autocmd("TermOpen", {
    desc = "Set local options for terminal buffer",
    group = vim.api.nvim_create_augroup("set-terminal-opts", { clear = true }),
    callback = function()
        local winid = vim.api.nvim_get_current_win()
        local current_win_opt = vim.wo[winid][0]

        current_win_opt.number = false
        current_win_opt.relativenumber = false
        current_win_opt.signcolumn = "no"
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
        local buffer = helpers.buf

        vim.keymap.set("n", "]q", function()
            vim.cmd("cn | wincmd p")

            buffer.highlight_line(buffer.get_qfline())
        end, opts)
        vim.keymap.set("n", "[q", function()
            vim.cmd("cp | wincmd p")

            buffer.highlight_line(buffer.get_qfline())
        end, opts)
    end,
})

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
    desc = "Lsp Progress Notification",
    group = vim.api.nvim_create_augroup("lsp-notification", { clear = true }),
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
        if not client or type(value) ~= "table" then
            return
        end
        local p = progress[client.id]

        for i = 1, #p + 1 do
            if i == #p + 1 or p[i].token == ev.data.params.token then
                p[i] = {
                    token = ev.data.params.token,
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
