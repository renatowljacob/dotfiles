return {
    {
        "folke/snacks.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
        },
        opts = {
            terminal = { enabled = true },
            notifier = {
                style = "fancy",
            },
            picker = {
                enabled = true,
                layout = function()
                    local layout = {
                        horizontal = {
                            layout = {
                                box = "horizontal",
                                width = 0.9,
                                min_width = 120,
                                height = 0.9,
                                {
                                    box = "vertical",
                                    border = "rounded",
                                    title = "{title} {live} {flags}",
                                    {
                                        win = "input",
                                        height = 1,
                                        border = "bottom",
                                    },
                                    { win = "list", border = "none" },
                                },
                                {
                                    win = "preview",
                                    title = "{preview}",
                                    border = "rounded",
                                    width = 0.65,
                                },
                            },
                        },
                        vertical = {
                            layout = {
                                backdrop = false,
                                width = 0.9,
                                min_width = 80,
                                height = 0.9,
                                min_height = 30,
                                box = "vertical",
                                border = "rounded",
                                title = "{title} {live} {flags}",
                                title_pos = "center",
                                {
                                    win = "input",
                                    height = 1,
                                    border = "bottom",
                                },
                                { win = "list", border = "none" },
                                {
                                    win = "preview",
                                    title = "{preview}",
                                    height = 0.65,
                                    border = "top",
                                },
                            },
                        },
                    }

                    return vim.o.columns >= 160 and layout.horizontal
                        or layout.vertical
                end,
                win = {
                    input = {
                        keys = {
                            ["<C-CR>"] = { "edit_vsplit", mode = { "i", "n" } },
                            ["<S-CR>"] = { "edit_split", mode = { "i", "n" } },
                        },
                    },
                    list = {
                        keys = {
                            ["<C-CR>"] = { "edit_vsplit", mode = { "i", "n" } },
                            ["<S-CR>"] = { "edit_split", mode = { "i", "n" } },
                        },
                    },
                },
            },
        },
        keys = {
            -- Snacks.picker
            {
                "<leader><leader>",
                function()
                    Snacks.picker.buffers()
                end,
                desc = "Find existing buffers",
            },
            {
                "<leader>s.",
                function()
                    Snacks.picker.recent()
                end,
                desc = 'Search Recent Files ("." for repeat)',
            },
            {
                "<leader>/",
                function()
                    Snacks.picker.lines()
                end,
                desc = "Fuzzily search in current buffer",
            },
            {
                "<leader>s/",
                function()
                    Snacks.picker.grep_buffers()
                end,
                desc = "Live Grep in Open Files",
            },
            {
                "<leader>sd",
                function()
                    Snacks.picker.diagnostics()
                end,
                desc = "Search Diagnostics",
            },
            {
                "<leader>sf",
                function()
                    Snacks.picker.files()
                end,
                desc = "Search Files",
            },
            {
                "<leader>sg",
                function()
                    Snacks.picker.grep()
                end,
                desc = "Search by Grep",
            },
            {
                "<leader>sh",
                function()
                    Snacks.picker.help()
                end,
                desc = "Search Help",
            },
            {
                "<leader>sH",
                function()
                    Snacks.picker.highlights()
                end,
                desc = "Search Highlights",
            },
            {
                "<leader>sk",
                function()
                    Snacks.picker.keymaps()
                end,
                desc = "Search Keymaps",
            },
            {
                "<leader>sm",
                function()
                    Snacks.picker.man()
                end,
                desc = "Search Man Pages",
            },
            {
                "<leader>sn",
                function()
                    Snacks.picker.files({
                        dirs = { vim.fn.stdpath("config") },
                    })
                end,
                desc = "Search Neovim files",
            },
            {
                "<leader>sp",
                function()
                    Snacks.picker.files({
                        rtp = true,
                    })
                end,
                desc = "Search Plugins",
            },
            {
                "<leader>sN",
                function()
                    Snacks.picker.notifications()
                end,
                desc = "Search Notifications",
            },
            {
                "<leader>ss",
                function()
                    Snacks.picker.pickers()
                end,
                desc = "Select Picker",
            },
            {
                "<leader>sr",
                function()
                    Snacks.picker.resume()
                end,
                desc = "Resume Search",
            },
            {
                "<leader>su",
                function()
                    Snacks.picker.undo()
                end,
                desc = "Search Undo Tree",
            },
            {
                "<leader>sw",
                function()
                    Snacks.picker.grep_word()
                end,
                desc = "Search For Word",
            },
        },
    },
}
