---@module "snacks"

-- TODO: Create a simple session manager for convenience

---@class MyApi Functions that I use throughout my config
---@field buf table Buffer-related functions
---@field cli table CLI command wrappers
---@field fs table Filesystem-related functions
---@field ft table Filetype-related functions
---@field treesitter table Treesitter-related functions
local MyApi = {}

MyApi.buf = {}
MyApi.cli = {}
MyApi.fs = {}
MyApi.ft = {}
MyApi.ft.c = {}
MyApi.ft.javascript = {}
MyApi.treesitter = {}

---@class State
---@field Snacks_terminal table snacks_terminal state
local State = {
    ---@class Snacks_terminal
    ---@field count number The count given for the last normal mode command
    ---@field keys string[] Mapped keys
    Snacks_terminal = {
        count = 1,
        keys = {
            "H",
            "J",
            "K",
            "L",
        },
    },
}

---Document symbols using a language server if present, otherwise use Treesitter
---@param opts? snacks.picker.lsp.symbols.Config
function MyApi.buf.document_symbols(opts)
    if
        not vim.tbl_isempty(
            vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
        )
    then
        return Snacks.picker.lsp_symbols(opts)
    end

    return Snacks.picker.treesitter()
end

---Get line and buffer number from a quickfix list item
---@return integer? bufnr, integer? lnum Buffer and line number
---If no quickfix list is found, nil is returned instead
function MyApi.buf.get_qfline()
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

---Apply highlight group to a line
---@param bufnr number Buffer that contains the line
---@param lnum number Line number to be highlighted
---@param opts? table Optional parameters
---                - higroup  highlight group (default "IncSearch")
---                - timeout in ms  (default 150)
function MyApi.buf.highlight_line(bufnr, lnum, opts)
    opts = opts or {}

    local higroup = opts.higroup or "IncSearch"
    local namespace = vim.api.nvim_create_namespace("highlight_quickfix")
    local timeout = opts.timeout or 150
    local winid =
        vim.fn.bufwinid(bufnr and bufnr or vim.api.nvim_get_current_buf())

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

---Toggle different snack terminals
---@param count? number
---@param opts? snacks.terminal.Opts
function MyApi.buf.toggle_nth_terminal(count, opts)
    State.Snacks_terminal.count = count or State.Snacks_terminal.count
    opts = opts
        or {
            auto_insert = false,
            win = {
                wo = {
                    winbar = "Terminal "
                        .. State.Snacks_terminal.keys[State.Snacks_terminal.count],
                },
            },
        }

    vim.cmd("normal! " .. State.Snacks_terminal.count)
    Snacks.terminal.toggle(nil, opts)
end

---Use dotbare as dotfiles/git fuzzy client
---@param args? string|string[] Command arguments
---@param opts? table  Optional parameters:
---                - git  Use dotbare as a generic git client (default false)
function MyApi.cli.dotbare(args, opts)
    args = args or {}
    opts = opts or {}
    opts.git = opts.git or false

    local command = { "dotbare" }

    if opts.git then
        table.insert(command, "--git")
    end

    command = vim.iter({ command, args }):flatten():totable()

    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.bo[bufnr].bufhidden = "wipe"
    vim.bo[bufnr].modifiable = false

    local height = math.ceil(vim.o.lines * 0.85)
    local width = math.ceil(vim.o.columns * 0.85)

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
        cwd = opts.git and vim.fn.getcwd() or vim.env.HOME,
        on_exit = function(_, status, _)
            if vim.api.nvim_win_is_valid(window) then
                vim.api.nvim_win_close(window, true)
            end

            -- If no files were selected or any other error
            if args == "fstat" or status ~= 0 then
                return nil
            end

            local buflist = vim.api.nvim_list_bufs()

            local lastbuf = buflist[#buflist]

            -- Necessary because list_bufs() includes unlisted buffers
            if vim.api.nvim_buf_is_valid(lastbuf) then
                vim.api.nvim_set_current_buf(lastbuf)
            end
        end,
        term = true,
    })

    -- Delete "leave terminal mode" buffer keymap since it's not modifiable anyway
    vim.keymap.del("t", "<Esc><Esc>", {
        buffer = bufnr,
    })

    vim.cmd.startinsert()
end

---Find root directory between two directories
---@param cwd string Cwd path
---@param bufpath string Buffer directory path
---@return string? root_dir Root directory shared between two paths
function MyApi.fs.find_root(cwd, bufpath)
    for dir in vim.fs.parents(bufpath) do
        if cwd:match(dir) then
            return dir
        end
    end
end

---Gets a C/C++ header file's source file equivalent or vice versa (e.g file.c returns file.h if it exists, file.h returns file.c)
---@param c_file string C/C++ file
---@return string? header Header file
function MyApi.ft.c.get_source_or_header(c_file)
    local basename = vim.fs.basename(c_file)

    local extension = basename:match(".*%.(%w+)")
    if extension ~= "c" and extension ~= "h" then
        return
    end

    local stem = basename:match("(.*)%.%w+")
    local files = vim.fs.find(function(file, _)
        return stem == file:match("(.*)%.%w+")
    end, {
        limit = math.huge,
        type = "file",
        path = vim.fs.dirname(basename),
    })

    if vim.tbl_isempty(files) then
        return
    end

    for _, file in ipairs(files) do
        if file:match(".*%.(%w+)") ~= extension then
            return file
        end
    end
end

---Gets a C/C++ source file's header file (e.g file.c returns file.h)
---@param source string C/C++ file
---@return string? header Header file
function MyApi.ft.c.get_header(source)
    local basename = vim.fs.basename(source)
    local extension = basename:match(".*%.(%w+)")

    if extension ~= "c" then
        return
    end

    return MyApi.ft.c.get_source_or_header(source)
end

---Gets a C/C++ header file's source file (e.g file.h returns file.c)
---@param header string C/C++ file
---@return string? source Source file
function MyApi.ft.c.get_source(header)
    local basename = vim.fs.basename(header)
    local extension = basename:match(".*%.(%w+)")

    if extension ~= "h" then
        return
    end

    return MyApi.ft.c.get_source_or_header(header)
end

-- TODO: finish this :P
function MyApi.ft.c.set_function_declaration()
    local buffers = vim.api.nvim_list_bufs()
    local bufnr = vim.api.nvim_get_current_buf()
    local current_file = vim.api.nvim_buf_get_name(bufnr)
    local header = MyApi.ft.c.get_header(current_file)

    if not vim.tbl_contains(buffers, header) then
        vim.cmd(
            "edit "
                .. header
                .. " | setlocal nobuflisted | setlocal bufhidden hide"
        )
    end
end

-- NOTE: Taken from https://github.com/JoosepAlviste/dotfiles/blob/master/config/nvim/lua/j/javascript.lua

---Turns a function into an async one if "await" is typed inside its body
function MyApi.ft.javascript.set_async()
    local node_types = {
        "function_declaration",
        "function_expression",
        "arrow_function",
    }

    local success, node =
        pcall(vim.treesitter.get_node, { ignore_injections = false })
    if not success or not node then
        return
    end

    local node_type = node:type()
    if node_type == "comment" then
        return
    end

    local cursor_col = vim.fn.col(".")
    local text = vim.fn.getline("."):sub(cursor_col - 4, cursor_col - 1)
    if text ~= "awai" then
        return
    end

    local node_ancestor =
        MyApi.treesitter.get_node_ancestor_by_type(node, node_types)
    if not node_ancestor then
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    if
        vim.startswith(
            vim.treesitter.get_node_text(node_ancestor, bufnr),
            "async"
        )
    then
        return
    end

    local row, col = node_ancestor:start()
    vim.api.nvim_buf_set_text(bufnr, row, col, row, col, { "async " })
end

---@param node TSNode
---@param types string[]
---@return TSNode? ancestor_node
function MyApi.treesitter.get_node_ancestor_by_type(node, types)
    local parent_node = node:tree():root():child_with_descendant(node)

    while parent_node do
        if vim.tbl_contains(types, parent_node:type()) then
            return parent_node
        end

        parent_node = parent_node:child_with_descendant(node)
    end

    return nil
end

return MyApi
