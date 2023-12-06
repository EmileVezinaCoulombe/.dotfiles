return {
    "echasnovski/mini.files",

    opts = {
        windows = { preview = true, width_focus = 30, width_preview = 30 },
        options = {
            -- Whether to use for editing directories
            use_as_default_explorer = true,
        },
        mappings = {
            close = "<ESC>",
        },
    },
    keys = {

        -- file explorer
        {
            "<leader>e",
            "<leader>fe",
            desc = "Explorer (file directory)",
            remap = true,
        },
        {
            "<leader>E",
            "<leader>fE",
            desc = "Explorer (cwd)",
            remap = true,
        },
        {
            "<leader>fe",
            function()
                require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
            end,
            desc = "Explorer (file directory)",
        },
        {
            "<leader>fE",
            function()
                require("mini.files").open(vim.loop.cwd(), true)
            end,
            desc = "Explorer (cwd)",
        },
    },
    config = function(_, opts)
        require("mini.files").setup(opts)

        local toggle_dotfiles = function()
            show_dotfiles = not show_dotfiles
            local new_filter = show_dotfiles and filter_show or filter_hide
            require("mini.files").refresh({
                content = {
                    filter = function(fs_entry)
                        return true
                    end,
                },
            })
        end
    end,
}
