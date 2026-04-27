local winid = vim.api.nvim_get_current_win()
local current_win_opt = vim.wo[winid][0]

current_win_opt.colorcolumn = "120"

-- From https://github.com/JoosepAlviste/dotfiles/blob/master/config/nvim/lua/j/javascript.lua
-- Colored function stuff
vim.keymap.set("i", "t", function()
    vim.api.nvim_feedkeys("t", "n", true)

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

    local node_types = {
        "function_declaration",
        "function_expression",
        "arrow_function",
    }

    local node_ancestor = nil
    do
        local parent_node = node:tree():root():child_with_descendant(node)
        while parent_node do
            if vim.tbl_contains(node_types, parent_node:type()) then
                node_ancestor = parent_node
                break
            end

            parent_node = parent_node:child_with_descendant(node)
        end
    end
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
end, { desc = "Add async to function declaration" })
