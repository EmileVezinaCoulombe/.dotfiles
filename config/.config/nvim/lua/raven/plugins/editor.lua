return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        "3rd/image.nvim",
        },
        config = {
        },
        keys = {
            {
                "<leader>e",
                "<cmd>Neotree toggle reveal position=right<cr>",
                desc = "Tree"

            }
        }
    },
    {
        "vim-apm",
        dir = "~/personal/vim-apm",
        keys = {
            {
                "<leader>um",
                function()
                    require("vim-apm"):toggle_monitor()
                end,
                desc = "vim apm",
            },
        },
    },
    {
        "mbbill/undotree",
        keys = {
            { "<leader>uu", "<cmd>UndotreeToggle", desc = "Undo tree toggle" },
        },
    },
    { "echasnovski/mini.nvim", version = false },
    {
        "Pocco81/auto-save.nvim",
        lazy = false,
        keys = { { "<leader>S", ":ASToggle<CR>", desc = "Toggle auto save" } },
        config = function(_, opts)
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
    {
        "HakonHarnes/img-clip.nvim",
        event = "BufEnter",
        opts = {},
        keys = {
            { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
        },
    },
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
    },
    {
        -- Temporary while the pr is merged
        -- "toppair/peek.nvim",
        "Saimo/peek.nvim",
        build = "deno task --quiet build:fast",
        keys = {
            {
                "<leader>up",
                function()
                    local peek = require("peek")
                    if peek.is_open() then
                        peek.close()
                    else
                        peek.open()
                    end
                end,
                desc = "Peek (Markdown Preview)",
            },
        },
        opts = { theme = "light", app = "browser" },
    },
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
    },
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
    },
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
    {
        "laytan/cloak.nvim",
        opts = {
            enabled = true,
            cloak_character = "*",
            cloak_length = 10,
            -- The applied highlight group (colors) on the cloaking, see `:h highlight`.
            highlight_group = "Comment",
            patterns = {
                {
                    file_pattern = {
                        ".env*",
                    },
                    -- Match an equals sign and any character after it.
                    cloak_pattern = { "=.+", "-.+" },
                },
            },
        },
        keys = {
            { "<leader>uh", "<cmd>CloakToggle", desc = "Cloak toggle" },
        },
    },
}
