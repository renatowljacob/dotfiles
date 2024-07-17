return {
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
	config = function() -- This is the function that runs, AFTER loading
		require("which-key").setup()

		-- Document existing key chains
		require("which-key").add({
			{
				{ "<leader>b", group = "Buffer" },
				{ "<leader>b_", hidden = true },
				{ "<leader>c", group = "Code" },
				{ "<leader>c_", hidden = true },
				{ "<leader>D", group = "Debug" },
				{ "<leader>D_", hidden = true },
				{ "<leader>d", group = "Document", icon = "󰈔" },
				{ "<leader>d_", hidden = true },
				{ "<leader>g", group = "Git" },
				{ "<leader>g_", hidden = true },
				{ "<leader>h", group = "Harpoon", icon = "󱡀" },
				{ "<leader>h_", hidden = true },
				{ "<leader>l", group = "List Files" },
				{ "<leader>l_", hidden = true },
				{ "<leader>n", group = "Neorg", icon = "󰏫" },
				{ "<leader>n_", hidden = true },
				{ "<leader>s", group = "Search" },
				{ "<leader>s_", hidden = true },
			},
		})
	end,
}
