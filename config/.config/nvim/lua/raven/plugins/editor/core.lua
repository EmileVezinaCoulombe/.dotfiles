local Util = require("raven.utils")

return {
    { "echasnovski/mini.nvim", version = false },
    -- search/replace in multiple files
    {
        "nvim-pack/nvim-spectre",
        cmd = "Spectre",
        opts = { open_cmd = "noswapfile vnew" },
        keys = {
            {
                "<leader>sr",
                function()
                    require("spectre").open()
                end,
                desc = "Replace in files (Spectre)",
            },
        },
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            keywords = {
                FIX = {
                    alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
                },
                TODO = { alt = { "todo" } },
                HACK = {},
                WARN = {},
                PERF = {},
                NOTE = {},
                TEST = {},
            },
        },
    },
    -- fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            -- { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            { "nvim-lua/plenary.nvim" },
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
                "<cmd>Telescope find_files<cr>",
                desc = "Find Files (root dir)",
            },
            {
                "<leader>ff",
                "<cmd>Telescope find_files<cr>",
                desc = "Find Files (root dir)",
            },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent file" },
            { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "commits search" },
            { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "status search" },
            -- search
            { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
            {
                "<leader>sa",
                "<cmd>Telescope autocommands<cr>",
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
            extension = {
            },
        },
    },
    -- which-key helps you remember key bindings by showing a popup
    -- with the active keybindings of the command you started typing.
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            plugins = { spelling = true },
            defaults = {
                mode = { "n", "v" },
                ["g"] = { name = "+goto" },
                ["gz"] = { name = "+surround" },
                ["]"] = { name = "+next" },
                ["["] = { name = "+prev" },
                ["<leader><tab>"] = { name = "+tabs" },
                ["<leader>b"] = { name = "+buffer" },
                ["<leader>c"] = { name = "+code" },
                ["<leader>f"] = { name = "+file/find" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>gh"] = { name = "+hunks" },
                ["<leader>q"] = { name = "+quit/session" },
                ["<leader>s"] = { name = "+search" },
                ["<leader>u"] = { name = "+ui" },
                ["<leader>w"] = { name = "+windows" },
                ["<leader>x"] = { name = "+diagnostics/quickfix" },
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.register(opts.defaults)
        end,
    }, -- gitsigns highlights text that has changed since the list
    -- git commit, and also lets you interactively stage & unstage
    -- hunks in a commit.
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
        },
        keys = {
            { "]h", "<cmd>Gitsigns next_hunk<cr>", desc = "Next Hunk" },
            { "[h", "<cmd>Gitsigns prev_hunk<cr>", desc = "Prev Hunk" },
            { "<leader>ghs", "<cmd>Gitsigns stage_hunk<CR>", desc = "Stage Hunk" },
            { "<leader>ghr", "<cmd>Gitsigns reset_hunk<CR>", desc = "Reset Hunk" },
            { "<leader>ghS", "<cmd>Gitsigns stage_buffer<cr>", desc = "Stage Buffer" },
            { "<leader>ghu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo Stage Hunk" },
            { "<leader>ghR", "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset Buffer" },
            { "<leader>ghp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview Hunk" },
            {
                "<leader>ghb",
                function()
                    require("gitsigns").blame_line({ full = true })
                end,
                desc = "Blame Line",
            },
            { "<leader>ghd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff This" },
            {
                "<leader>ghD",
                function()
                    require("gitsigns").diffthis("~")
                end,
                desc = "Diff This ~",
            },
        },
    }, -- better diagnostics list and others
    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        opts = { use_diagnostic_signs = true },
        keys = {
            {
                "<leader>xx",
                "<cmd>TroubleToggle document_diagnostics<cr>",
                desc = "Document Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>TroubleToggle workspace_diagnostics<cr>",
                desc = "Workspace Diagnostics (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>TroubleToggle loclist<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>TroubleToggle quickfix<cr>",
                desc = "Quickfix List (Trouble)",
            },
            {
                "[q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").previous({
                            skip_groups = true,
                            jump = true,
                        })
                    else
                        local ok, err = pcall(vim.cmd.cprev)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Previous trouble/quickfix item",
            },
            {
                "]q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").next({
                            skip_groups = true,
                            jump = true,
                        })
                    else
                        local ok, err = pcall(vim.cmd.cnext)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Next trouble/quickfix item",
            },
        },
    },
}
