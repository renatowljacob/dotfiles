return {
	{
		"rmagatti/auto-session",
		lazy = false,

		--- enables autocomplete for opts
		---@module "auto-session"
		---@type AutoSession.Config
		opts = {
			auto_create = false,
			session_lens = {
				load_on_setup = false,
			},
			mappings = {
				delete_session = {},
				alternate_session = {},
				copy_session = {},
			},
		},
	},
}
