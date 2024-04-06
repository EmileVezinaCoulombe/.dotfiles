return {
    { "github/copilot.vim" },
    { "eandrju/cellular-automaton.nvim" },
    { "gpanders/editorconfig.nvim" },
    { "folke/lazy.nvim", version = "*" },
    { "nvim-lua/plenary.nvim", lazy = true },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            -- { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            { "nvim-lua/plenary.nvim" },
            {
                "ahmedkhalf/project.nvim",
                opts = {},
                event = "VeryLazy",
                config = function(_, opts)
                    require("project_nvim").setup(opts)
                    require("telescope").load_extension("projects")
                end,
                keys = {
                    { "<leader>fp", "<Cmd>Telescope projects<CR>", desc = "Projects" },
                },
            },
        },
        tag = "0.1.3",
        cmd = "Telescope",
        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)
        end,
        keys = {
            {
                "<leader>,",
                "<cmd>Telescope buffers show_all_buffers=true<cr>",
                desc = "Switch Buffer",
            },
            {
                "<leader>s:",
                "<cmd>Telescope command_history<cr>",
                desc = "Command History",
            },
            { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
            {
                "<leader><leader>",
                "<cmd>Telescope find_files hidden=true<cr>",
                desc = "Find Files (root dir)",
            },
            {
                "<leader>ff",
                "<cmd>Telescope find_files hidden=true no_ignore=true<cr>",
                desc = "Auto Commands",
            },
            {
                "<leader>sb",
                "<cmd>Telescope current_buffer_fuzzy_find<cr>",
                desc = "Buffer",
            },
            { "<leader>sc", "<cmd>Telescope commands<cr>", desc = "Commands" },
            {
                "<leader>sC",
                "<cmd>Telescope command_history<cr>",
                desc = "Command History",
            },
            {
                "<leader>sd",
                "<cmd>Telescope diagnostics bufnr=0<cr>",
                desc = "Document diagnostics",
            },
            {
                "<leader>sD",
                "<cmd>Telescope diagnostics<cr>",
                desc = "Workspace diagnostics",
            },
            {
                "<leader>sg",
                function()
                    require("telescope.builtin").live_grep({ additional_args = { "-j1" } })
                end,
                desc = "Grep",
            },
            { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
            {
                "<leader>sH",
                "<cmd>Telescope highlights<cr>",
                desc = "Search Highlight Groups",
            },
            { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
            { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
            { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
            { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
            { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume last search" },
            {
                "<leader>sw",
                function()
                    require("telescope.builtin").grep_string({ word_match = "-w" })
                end,
                desc = "Word",
            },
            {
                "<leader>uC",
                function()
                    require("telescope.builtin").colorscheme({ enable_preview = true })
                end,
                desc = "Colorscheme with preview",
            },
            {
                "<leader>ss",
                "<cmd>Telescope lsp_document_symbols<cr>",
                desc = "Goto Symbol",
            },
            {
                "<leader>sS",
                "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
                desc = "Goto Symbol (Workspace)",
            },
        },
        opts = {
            defaults = {
                prompt_prefix = " ",
                selection_caret = " ",
            },
            extension = {},
        },
    },
}
