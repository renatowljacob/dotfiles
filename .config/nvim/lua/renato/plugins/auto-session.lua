return {
    {
        "rmagatti/auto-session",
        lazy = false,

        --- enables autocomplete for opts
        ---@module "auto-session"
        ---@type AutoSession.Config
        opts = {
            auto_create = false,
            auto_save = true,
            session_lens = {
                load_on_setup = false,
            },
            mappings = {
                delete_session = {},
                alternate_session = {},
                copy_session = {},
            },
            post_restore_cmds = {
                function()
                    vim.fn.chdir(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
                end,
            },
        },
    },
}
