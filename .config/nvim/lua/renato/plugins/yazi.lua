return {
    {
        "mikavilpas/yazi.nvim",
        event = "VeryLazy",
        keys = {
            {
                "<leader>lf",
                "<cmd>Yazi cwd<cr>",
                desc = "List files",
            },
        },
        opts = {
            -- if you want to open yazi instead of netrw, see below for more info
            open_for_directories = true,
        },
    },
}
