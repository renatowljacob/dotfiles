vim.api.nvim_create_autocmd("TextChanged", {
    desc = "Highlight checkhealth list items",
    group = vim.api.nvim_create_augroup("highlight-checkhealth", {
        clear = true,
    }),
    once = true,
    callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local ns = vim.api.nvim_create_namespace("checkhealth-hl")
        local patterns = {
            ["- WARNING"] = "DiagnosticVirtualTextWarn",
            ["- ERROR"] = "DiagnosticVirtualTextError",
        }

        for index, line in ipairs(lines) do
            local lnum = index - 1

            for key, pattern in pairs(patterns) do
                if string.find(line, key) then
                    vim.hl.range(bufnr, ns, pattern, { lnum, 0 }, { lnum, -1 })
                end
            end
        end
    end,
})
