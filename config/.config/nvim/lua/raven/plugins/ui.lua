return {
    { "nvim-tree/nvim-web-devicons", lazy = true },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            local opts = {
                debounce = 100,
                whitespace = {
                    remove_blankline_trail = false,
                },
                indent = { char = require("raven.core").icons.indent.char },
                exclude = {
                    filetypes = {
                        "checkhealth",
                        "gitcommit",
                        "help",
                        "lazy",
                        "lazyterm",
                        "lspinfo",
                        "man",
                        "mason",
                        "neo-tree",
                        "trouble",
                        "",
                    },
                },
                scope = {
                    show_start = false,
                    include = { node_type = { lua = { "return_statement", "table_constructor", "block", "chunk" } } },
                },
            }

            require("ibl").setup(opts)
        end,
    },
    {
        "NvChad/nvim-colorizer.lua",
        config = true,
        opts = {
            filetypes = { "*", css = { name = true } },
            user_default_options = {
                tailwind = true,
                RGB = true, -- #RGB hex codes
                RRGGBB = true, -- #RRGGBB hex codes
                names = false, -- "Name" codes like Blue
                RRGGBBAA = false, -- #RRGGBBAA hex codes
                rgb_fn = false, -- CSS rgb() and rgba() functions
                hsl_fn = false, -- CSS hsl() and hsla() functions
                css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
                mode = "background", -- set the display mode.
            },
        },
    },
    {
        "folke/zen-mode.nvim",
        opts = {
            plugins = {
                gitsigns = true,
                kitty = { enabled = true, font = "+1" },
            },
        },
        keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "zen mode" } },
    },
}
