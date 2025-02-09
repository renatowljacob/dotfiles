-- Functions used in my config

---@class Helpers
---@field buf table Buffer functions
---@field fs table Filesystem functions
---@field telescope table Telescope functions
local M = {}

M.buf = {}
M.fs = {}
M.telescope = {}

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
---              - higroup
---              - timeout in ms
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

function M.telescope.dotbare(opts)
    local config = require("telescope.config").values
    local finders = require("telescope.finders")
    local make_entry = require("telescope.make_entry")
    local pickers = require("telescope.pickers")
    local previewers = require("telescope.previewers")

    opts = opts or {}
    opts.git = opts.git or false
    opts.cwd = opts.git and vim.fn.getcwd() or vim.fn.glob(vim.env.HOME)

    local dotbare_opts = function(args, opt)
        if args == "fadd" then
            if opt == "entry" then
                return make_entry.gen_from_git_status(opts)
            elseif opt == "previewer" then
                return previewers.git_file_diff()
            elseif opt == "prompt" then
                return "Git Add"
            end
        elseif args == "fedit" then
            if opt == "entry" then
                return make_entry.gen_from_file(opts)
            elseif opt == "previewer" then
                return ""
            elseif opt == "prompt" then
                return "Git Files"
            end
        elseif args == "fgrep" then
            if opt == "entry" then
                return make_entry.gen_from_vimgrep(opts)
            elseif opt == "previewer" then
                return ""
            elseif opt == "prompt" then
                return "Git Grep"
            end
        elseif args == "flog" then
            if opt == "entry" then
                return make_entry.gen_from_git_commits(opts)
            elseif opt == "previewer" then
                return ""
            elseif opt == "prompt" then
                return "Git Log"
            end
        elseif args == "fstatus" then
            if opt == "entry" then
                return make_entry.gen_from_git_status(opts)
            elseif opt == "previewer" then
                return ""
            elseif opt == "prompt" then
                return "Git Status"
            end
        elseif args == "fstash" then
            if opt == "entry" then
                return make_entry.gen_from_git_stash(opts)
            elseif opt == "previewer" then
                return ""
            elseif opt == "prompt" then
                return "Git Stash"
            end
        end
    end

    if not opts.args then
        return
    end

    local finder = finders.new_async_job({
        command_generator = function(prompt)
            local args = { "dotbare" }

            if opts.git then
                table.insert(args, "--git")
            end
            table.insert(args, opts.args)

            return args
        end,
        entry_maker = dotbare_opts(opts.args, "entry"),
        cwd = opts.cwd,
    })

    pickers
        .new(opts, {
            debounce = 100,
            prompt_title = dotbare_opts(opts.args, "prompt"),
            finder = finder,
            previewer = config.file_previewer(opts),
            sorter = require("telescope.sorters").empty(),
        })
        :find()
end

return M
