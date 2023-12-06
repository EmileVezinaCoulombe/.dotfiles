return {
    {
        "Pocco81/auto-save.nvim",
        lazy = false,
        keys = { { "<leader>S", ":ASToggle<CR>", desc = "Toggle auto save" } },
        config = function (_, opts)
            require("auto-save").setup(opts)
        end,
        opts = {
            enabled = true,
            execution_message = {
                message = function() -- message to print on save
                    return ""
                end,
                dim = 0, -- dim the color of `message`
                cleaning_interval = 0, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
            },
            trigger_events = { "InsertLeave" }, -- vim events that trigger auto-save. See :h events
        },
    },
}
