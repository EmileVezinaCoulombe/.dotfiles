return {
    -- Use this to add any additional keymaps
    -- for specific lsp servers
    ---@type LazyKeys[]
    settings = {
        Lua = {
            workspace = { checkThirdParty = false },
            completion = { callSnippet = "Replace" },
        },
    },
}
