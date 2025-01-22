return {
    {
        -- NOTE: Plugins can specify dependencies.
        --
        -- The dependencies are proper plugin specifications as well - anything
        -- you do for a plugin at the top level, you can do for a dependency.
        --
        -- Use the `dependencies` key to specify the dependencies of a particular plugin

        -- Fuzzy Finder (files, lsp, etc)
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { -- If encountering errors, see telescope-fzf-native README for installation instructions
                "nvim-telescope/telescope-fzf-native.nvim",

                -- `build` is used to run some command when the plugin is installed/updated.
                -- This is only run then, not every time Neovim starts up.
                build = "make",

                -- `cond` is a condition used to determine whether this plugin should be
                -- installed and loaded.
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            "nvim-telescope/telescope-ui-select.nvim",
            "debugloop/telescope-undo.nvim",
            -- Useful for getting pretty icons, but requires a Nerd Font.
            { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
        },
        config = function()
            local telescope = require("telescope")

            -- Telescope is a fuzzy finder that comes with a lot of different things that
            -- it can fuzzy find! It's more than just a "file finder", it can search
            -- many different aspects of Neovim, your workspace, LSP, and more!
            --
            -- The easiest way to use Telescope, is to start by doing something like:
            --  :Telescope help_tags
            --
            -- After running this command, a window will open up and you're able to
            -- type in the prompt window. You'll see a list of `help_tags` options and
            -- a corresponding preview of the help.
            --
            -- Two important keymaps to use while in Telescope are:
            --  - Insert mode: <c-/>
            --  - Normal mode: ?
            --
            -- This opens a window that shows you all of the keymaps for the current
            -- Telescope picker. This is really useful to discover what Telescope can
            -- do as well as how to actually do it!

            -- Open multiple files as buffers
            local select_one_or_multi = function(prompt_bufnr)
                local picker =
                    require("telescope.actions.state").get_current_picker(
                        prompt_bufnr
                    )
                local multi = picker:get_multi_selection()
                if not vim.tbl_isempty(multi) then
                    require("telescope.actions").close(prompt_bufnr)
                    for _, j in pairs(multi) do
                        if j.path ~= nil then
                            vim.cmd(string.format("%s %s", "edit", j.path))
                        end
                    end
                else
                    require("telescope.actions").select_default(prompt_bufnr)
                end
            end

            -- [[ Configure Telescope ]]
            -- See `:help telescope` and `:help telescope.setup()`
            telescope.setup({
                -- You can put your default mappings / updates / etc. in here
                --  All the info you're looking for is in `:help telescope.setup()`
                --
                defaults = {
                    layout_strategy = "flex",
                    layout_config = {
                        flex = {
                            flip_columns = 160,
                            width = 0.9,
                        },
                        horizontal = {
                            height = 0.9,
                            width = 0.9,
                            mirror = true,
                            preview_width = 0.6,
                            prompt_position = "top",
                        },
                        vertical = {
                            height = 0.9,
                            width = 0.9,
                            mirror = true,
                            preview_height = 0.55,
                            preview_cutoff = 30,
                            prompt_position = "top",
                        },
                    },
                    sorting_strategy = "ascending",
                    mappings = {
                        i = {
                            ["<CR>"] = select_one_or_multi,
                            ["<C-Enter>"] = "file_vsplit",
                            ["<S-Enter>"] = "file_split",
                        },
                        n = {
                            ["<CR>"] = select_one_or_multi,
                            ["<C-Enter>"] = "file_vsplit",
                            ["<S-Enter>"] = "file_split",
                        },
                    },
                    path_display = { "smart" },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_cursor(),
                    },
                },
            })

            -- Enable Telescope extensions if they are installed
            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")
            pcall(require("telescope").load_extension, "undo")

            -- See `:help telescope.builtin`
            local builtin = require("telescope.builtin")
            vim.keymap.set(
                "n",
                "<leader>gb",
                builtin.git_bcommits,
                { desc = "Search Git Buffer Commits" }
            )
            vim.keymap.set(
                "n",
                "<leader>gc",
                builtin.git_commits,
                { desc = "Search Git Commits" }
            )
            vim.keymap.set(
                "n",
                "<leader>gf",
                builtin.git_files,
                { desc = "Search Git Files" }
            )
            vim.keymap.set(
                "n",
                "<leader>gr",
                builtin.git_branches,
                { desc = "Search Git Branches" }
            )
            vim.keymap.set(
                "n",
                "<leader>gs",
                builtin.git_status,
                { desc = "Search Git Status" }
            )
            vim.keymap.set(
                "n",
                "<leader><leader>",
                builtin.buffers,
                { desc = "Find existing buffers" }
            )
            vim.keymap.set(
                "n",
                "<leader>s.",
                builtin.oldfiles,
                { desc = 'Search Recent Files ("." for repeat)' }
            )
            vim.keymap.set(
                "n",
                "<leader>sd",
                builtin.diagnostics,
                { desc = "Search Diagnostics" }
            )
            vim.keymap.set(
                "n",
                "<leader>sg",
                builtin.live_grep,
                { desc = "Search by Grep" }
            )
            vim.keymap.set(
                "n",
                "<leader>sh",
                builtin.help_tags,
                { desc = "Search Help" }
            )
            vim.keymap.set(
                "n",
                "<leader>sH",
                builtin.highlights,
                { desc = "Search Highlights" }
            )
            vim.keymap.set(
                "n",
                "<leader>sk",
                builtin.keymaps,
                { desc = "Search Keymaps" }
            )
            vim.keymap.set(
                "n",
                "<leader>sr",
                builtin.resume,
                { desc = "Search Resume" }
            )
            vim.keymap.set(
                "n",
                "<leader>ss",
                builtin.builtin,
                { desc = "Search Select Telescope" }
            )
            vim.keymap.set(
                "n",
                "<leader>su",
                "<cmd>Telescope undo<CR>",
                { desc = "Search undo tree" }
            )
            vim.keymap.set(
                "n",
                "<leader>sw",
                builtin.grep_string,
                { desc = "Search Current Word" }
            )

            -- Slightly advanced example of overriding default behavior and theme
            vim.keymap.set("n", "<leader>/", function()
                -- You can pass additional configuration to Telescope to change the theme, layout, etc.
                builtin.current_buffer_fuzzy_find(
                    require("telescope.themes").get_dropdown({
                        previewer = false,
                    })
                )
            end, { desc = "Fuzzily search in current buffer" })

            -- It's also possible to pass additional configuration options.
            --  See `:help telescope.builtin.live_grep()` for information about particular keys
            vim.keymap.set("n", "<leader>s/", function()
                builtin.live_grep({
                    grep_open_files = true,
                    prompt_title = "Live Grep in Open Files",
                })
            end, { desc = "Search in Open Files" })

            -- Show hidden files
            vim.keymap.set("n", "<leader>sf", function()
                builtin.find_files({ hidden = true })
            end, { desc = "Search Files" })

            vim.keymap.set("n", "<leader>sm", function()
                builtin.man_pages({ sections = { "ALL" } })
            end, { desc = "Search Man Pages" })

            -- Shortcut for searching your Neovim configuration files
            vim.keymap.set("n", "<leader>sn", function()
                builtin.find_files({ cwd = vim.fn.stdpath("config") })
            end, { desc = "Search Neovim files" })

            -- Search Neovim plugin files
            vim.keymap.set("n", "<leader>sp", function()
                builtin.find_files({
                    ---@diagnostic disable-next-line:param-type-mismatch
                    cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
                })
            end, { desc = "Search plugin files" })

            vim.keymap.set("n", "<leader>sN", function()
                builtin.find_files({ cwd = "~/Documents/notes/" })
            end, { desc = "Search Notes" })
        end,
    },
}
