-- Functions used in my config

---@class Helpers
---@field buf table Buffer functions
---@field cmd table CLI command wrappers
---@field fs table Filesystem functions
local M = {}

M.buf = {}
M.cmd = {}
M.fs = {}

---Get line and buffer number from a quickfix list item
---@return integer? bufnr, integer? lnum Buffer and line number
---If no quickfix list is found, nil is returned instead
function M.buf.get_qfline()
    ---@type table
    local qflist = vim.fn.getqflist()

    if vim.tbl_isempty(qflist) then
        return nil
    end

    local index = vim.fn.getqflist({ idx = 0 }).idx
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
---@return nil
function M.buf.highlight_line(bufnr, lnum, opts)
    opts = opts or {}

    local higroup = opts.higroup or "IncSearch"
    local namespace = vim.api.nvim_create_namespace("highlight_quickfix")
    local timeout = opts.timeout or 150
    local timer ---@type uv.uv_timer_t
    local winid = vim.fn.bufwinid(bufnr)

    local clear_hl = function()
        pcall(vim.api.nvim_buf_clear_namespace, bufnr, namespace, 0, -1)
        pcall(vim.api.nvim__win_del_ns, vim.fn.bufwinid(bufnr), namespace)
    end

    vim.api.nvim__win_add_ns(winid, namespace)

    vim.highlight.range(
        bufnr,
        namespace,
        higroup,
        { lnum, 0 },
        { lnum, vim.fn.col("$") }
    )

    if timer then
        timer:close()
        assert(clear_hl)
        clear_hl()
    end

    timer = vim.defer_fn(clear_hl, timeout)
end

---Find root directory between two directories
---@param cwd string Cwd path
---@param bufpath string Buffer directory path
---@return string? root_dir Root directory shared between two paths
function M.fs.find_root(cwd, bufpath)
    for dir in vim.fs.parents(bufpath) do
        if cwd:match(dir) then
            return dir
        end
    end
end

---Use dotbare as dotfiles/git fuzzy client
---@param args? string|string[] Command arguments
---@param opts? table  Optional parameters:
---                - git  Use dotbare as a generic git client (default false)
function M.cmd.dotbare(args, opts)
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
        -- style = "minimal",
        height = height,
        width = width,
        border = "solid",
        col = math.ceil((vim.o.columns - width) / 2),
        row = math.ceil((vim.o.lines - height) / 2),
    })

    vim.api.nvim_set_current_win(window)

    vim.fn.termopen(command, {
        cwd = opts.git and vim.fn.getcwd() or vim.env.HOME,
        on_exit = function(_, status, _)
            if vim.api.nvim_win_is_valid(window) then
                vim.api.nvim_win_close(window, true)
            end

            -- If no files were selected or any other error
            if status ~= 0 then
                return nil
            end

            local buflist = vim.api.nvim_list_bufs()
            local lastbuf = buflist[#buflist]

            -- Necessary because list_bufs() includes unlisted buffers
            if vim.api.nvim_buf_is_valid(lastbuf) then
                vim.api.nvim_set_current_buf(lastbuf)
            end
        end,
    })

    -- Delete "leave terminal mode" buffer keymap since it's not modifiable anyway
    vim.keymap.del("t", "<Esc><Esc>", {
        buffer = bufnr,
    })

    vim.cmd.startinsert()
end

return M
