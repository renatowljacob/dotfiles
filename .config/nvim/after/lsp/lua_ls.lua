return {
    -- cmd = {...},
    -- filetypes = { ...},
    -- capabilities = {},
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace",
            },
            hint = {
                enable = true,
                setType = true,
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
        },
    },
}
