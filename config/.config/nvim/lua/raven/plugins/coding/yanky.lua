return {
    -- better yank/paste
    {
        "gbprod/yanky.nvim",
        opts = function()
            return {
                highlight = { timer = 100 },
            }
        end,
        keys = {
            {
                "<leader>sy",
                function()
                    require("telescope").extensions.yank_history.yank_history({})
                end,
                desc = "Open Yank History",
            },
        },
    },
}
