return {
    {
        -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
        --
        -- This is often very useful to both group configuration, as well as handle
        -- lazy loading plugins that don't need to be loaded immediately at startup.
        --
        -- For example, in the following configuration, we use:
        --  event = 'VimEnter'
        --
        -- which loads which-key before all the UI elements are loaded. Events can be
        -- normal autocommands events (`:help autocmd-events`).
        --
        -- Then, because we use the `config` key, the configuration only runs
        -- after the plugin has been loaded:
        --  config = function() ... end

        -- Useful plugin to show you pending keybinds.
        "folke/which-key.nvim",
        event = "VimEnter", -- Sets the loading event to 'VimEnter'
        opts = {
            delay = 300,
            preset = "helix",
            spec = {
                { "gr", group = "Code" },
                { "gr_", hidden = true },
                { "<leader>d", group = "Document", icon = "󰈔" },
                { "<leader>d_", hidden = true },
                { "<leader>g", group = "Git" },
                { "<leader>g_", hidden = true },
                { "<leader>h", group = "Harpoon", icon = "󱡀" },
                { "<leader>h_", hidden = true },
                {
                    "<leader>l",
                    group = "List Files",
                    icon = {
                        icon = "",
                        color = "blue",
                    },
                },
                { "<leader>l_", hidden = true },
                {
                    "<leader>n",
                    group = "Neovim",
                    icon = {
                        icon = "",
                        color = "green",
                    },
                },
                { "<leader>n_", hidden = true },
                {
                    "<leader>o",
                    group = "Operations",
                    icon = {
                        icon = "󰾋",
                        color = "purple",
                    },
                },
                { "<leader>o_", hidden = true },
                { "<leader>p", group = "Project" },
                { "<leader>p_", hidden = true },
                { "<leader>s", group = "Search" },
                { "<leader>s_", hidden = true },
                {
                    "<leader>t",
                    group = "Testing",
                    icon = {
                        icon = "󰃤",
                        color = "red",
                    },
                },
                { "<leader>t_", hidden = true },
            },
        },
    },
}
