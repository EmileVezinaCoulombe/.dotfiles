return {
    -- auto pairs
    {
        "echasnovski/mini.pairs",
        config = function(_, opts)
            require("mini.pairs").setup(opts)
        end,
    },
    {
        "echasnovski/mini.surround",
        config = function(_, opts)
            require("mini.surround").setup(opts)
        end,
    }, -- comments
    { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
    {
        "echasnovski/mini.comment",
        config = function(_, opts)
            require("mini.comment").setup(opts)
        end,
    }, -- Better text-objects
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter-textobjects" },
        opts = function()
            local ai = require("mini.ai")
            return {
                n_lines = 500,
                custom_textobjects = {
                    o = ai.gen_spec.treesitter({
                        a = {
                            "@block.outer",
                            "@conditional.outer",
                            "@loop.outer",
                        },
                        i = {
                            "@block.inner",
                            "@conditional.inner",
                            "@loop.inner",
                        },
                    }, {}),
                    f = ai.gen_spec.treesitter({
                        a = "@function.outer",
                        i = "@function.inner",
                    }, {}),
                    c = ai.gen_spec.treesitter({
                        a = "@class.outer",
                        i = "@class.inner",
                    }, {}),
                },
            }
        end,
        config = function(_, opts)
            require("mini.ai").setup(opts)
            -- register all text objects with which-key
            ---@type table<string, string|table>
            local i = {
                [" "] = "Whitespace",
                ["?"] = "User Prompt",
                _ = "underscore",
                a = "argument",
                c = "class",
                f = "function",
                o = "block, conditional, loop",
                q = "quote `, \", '",
            }
            require("which-key").register({ mode = { "o", "x" }, i = i, a = i })
        end,
    },
}
