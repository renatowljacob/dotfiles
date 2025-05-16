vim.wo[vim.api.nvim_get_current_win()][0].foldenable = true

local myapi = require("renato.core.myapi")
local bufnr = vim.api.nvim_get_current_buf()

local file =
    myapi.ft.c.get_source(vim.fs.basename(vim.api.nvim_buf_get_name(bufnr)))

if file then
    local extension = file:match(".*%.(%w+)")
    if extension == "c" then
        vim.bo[bufnr].filetype = "c"
    elseif extension == "cpp" then
        vim.bo[bufnr].filetype = "cpp"
    end
end

-- WARN: WIP feature
vim.api.nvim_create_autocmd("InsertLeave", {
    group = vim.api.nvim_create_augroup("set_prototypes", { clear = true }),
    callback = function()
        local bufnrs = vim.api.nvim_list_bufs()
        local buffers = {}

        for _, value in ipairs(bufnrs) do
            buffers[vim.api.nvim_buf_get_name(value)] = value
        end

        -- Current source file
        local currbufnr = vim.api.nvim_get_current_buf()
        local current_file = vim.api.nvim_buf_get_name(currbufnr)

        if current_file:match(".*%.(%w+)") == "h" then
            return
        end

        -- Respective header file
        local header = myapi.ft.c.get_header(current_file)
        local headerbufnr = nil

        if not header then
            return
        end

        header = vim.fs.abspath(header)

        if not buffers[header] then
            headerbufnr = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_name(headerbufnr, header)
            vim.api.nvim_buf_call(headerbufnr, vim.cmd.edit)
        else
            headerbufnr = buffers[header]
        end

        local parser, err = vim.treesitter.get_parser()
        if err or not parser then
            return
        end

        local tree = parser:parse(true)[1]
        if not tree then
            return
        end

        local root = tree:root()
        local includes = {}

        for node, _ in root:iter_children() do
            if
                node:type() == "preproc_include"
                and node:field("path")[1]:type() == "string_literal"
            then
                local start_row, start_col, end_row, end_col =
                    node:field("path")[1]:child(1):range(false)

                table.insert(
                    includes,
                    vim.api.nvim_buf_get_text(
                        0,
                        start_row,
                        start_col,
                        end_row,
                        end_col,
                        {}
                    )[1]
                )
            end
        end

        vim.print(includes)
    end,
})

-- include <sys.h>
--
-- (preproc_include ; [0, 0] - [1, 0]
--   path: (system_lib_string)) ; [0, 9] - [0, 18]

-- include "somelib.h"
--
-- (preproc_include ; [1, 0] - [2, 0]
--   path: (string_literal ; [1, 9] - [1, 35]
--     (string_content))) ; [1, 10] - [1, 34]

-- function declaration (prototype)
--
-- (declaration ; [3, 0] - [3, 23]
--   type: (primitive_type) ; [3, 0] - [3, 4]
--   declarator: (function_declarator ; [3, 5] - [3, 22]
--     declarator: (identifier) ; [3, 5] - [3, 8]
--     parameters: (parameter_list ; [3, 8] - [3, 22]
--       (parameter_declaration ; [3, 9] - [3, 14]
--         type: (primitive_type) ; [3, 9] - [3, 12]
--         declarator: (identifier)) ; [3, 13] - [3, 14]
--       (parameter_declaration ; [3, 16] - [3, 21]
--         type: (primitive_type) ; [3, 16] - [3, 19]
--         declarator: (identifier))))) ; [3, 20] - [3, 21]

-- function definition
--
-- (function_definition ; [15, 0] - [15, 25]
--   type: (primitive_type) ; [15, 0] - [15, 4]
--   declarator: (function_declarator ; [15, 5] - [15, 22]
--     declarator: (identifier) ; [15, 5] - [15, 8]
--     parameters: (parameter_list ; [15, 8] - [15, 22]
--       (parameter_declaration ; [15, 9] - [15, 14]
--         type: (primitive_type) ; [15, 9] - [15, 12]
--         declarator: (identifier)) ; [15, 13] - [15, 14]
--       (parameter_declaration ; [15, 16] - [15, 21]
--         type: (primitive_type) ; [15, 16] - [15, 19]
--         declarator: (identifier)))) ; [15, 20] - [15, 21]
--   body: (compound_statement))) ; [15, 23] - [15, 25]
