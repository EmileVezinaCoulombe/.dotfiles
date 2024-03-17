return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                tailwindcss = {
                },
            },
            setup = {
                tailwindcss = function(_, opts)
                    local tw = require("lspconfig.server_configurations.tailwindcss")
                    --- @param ft string
                    require("lspconfig").tailwindcss.setup({
                        filetypes = table.insert(tw.default_config.filetypes, table.unpack({"rust"}))
                    });
                end,
            },
        },
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
        },
        opts = function(_, opts)
            -- FIXME: get this shit running
            --   local format_kinds = opts.formatting.format
            --   opts.formatting.format = function(entry, item)
            --       format_kinds(entry, item) -- add icons
            --       return require("tailwindcss-colorizer-cmp").formatter(entry, item)
            --   end
        end,
    },
}
