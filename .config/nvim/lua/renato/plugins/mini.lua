return {
    {
        -- Collection of various small independent plugins/modules
        "nvim-mini/mini.nvim",
        config = function()
            require("mini.pairs").setup()
            require("mini.splitjoin").setup()
            require("mini.tabline").setup()

            local map_bs = function(lhs, rhs)
                vim.keymap.set(
                    "i",
                    lhs,
                    rhs,
                    { expr = true, replace_keycodes = false }
                )
            end

            map_bs("<C-h>", function()
                return MiniPairs.bs()
            end)
            map_bs("<C-w>", function()
                return MiniPairs.bs("\23")
            end)
            map_bs("<C-u>", function()
                return MiniPairs.bs("\21")
            end)

            -- Better Around/Inside textobjects
            --
            -- Examples:
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [']quote
            --  - ci'  - [C]hange [I]nside [']quote
            require("mini.ai").setup({ n_lines = 500 })

            -- Add/delete/replace surroundings (brackets, quotes, etc.)
            --
            -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
            -- - sd'   - [S]urround [D]elete [']quotes
            -- - sr)'  - [S]urround [R]eplace [)] [']
            require("mini.surround").setup()

            -- Simple and easy statusline.
            --  You could remove this setup call if you don't like it,
            --  and try some other statusline plugin
            local statusline = require("mini.statusline")
            -- set use_icons to true if you have a Nerd Font
            statusline.setup({
                use_icons = vim.g.have_nerd_font,
            })

            -- You can configure sections in the statusline by overriding their
            -- default behavior. For example, here we set the section for
            -- cursor location to LINE:COLUMN
            ---@diagnostic disable-next-line: duplicate-set-field
            statusline.section_location = function()
                return "%2l:%-2v"
            end

            -- ... and there is more!
            --  Check out: https://github.com/echasnovski/mini.nvim
        end,
    },
}
