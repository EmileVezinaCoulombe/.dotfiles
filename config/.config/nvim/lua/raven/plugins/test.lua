return {
    {
        "folke/which-key.nvim",
        optional = true,
        opts = { defaults = { ["<leader>t"] = { name = "+test" } } },
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-neotest/nvim-nio",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-python",
        },
        config = function(_, _)
            require("neotest").setup({
                -- Can be a list of adapters like what neotest expects,
                -- or a list of adapter names,
                -- or a table of adapter names, mapped to adapter configs.
                -- The adapter will then be automatically loaded with the config.
                adapters = {
                    require("rustaceanvim.neotest")({}),
                    ["neotest-python"] = {
                        -- Here you can specify the settings for the adapter, i.e.
                        -- runner = "pytest",
                        -- python = ".venv/bin/python",

                        dap = { justMyCode = false },
                        runner = "unittest",
                        -- TODO: use venv plugin
                        python = require("raven.utils").venv_python_path,
                    },
                },
                status = { virtual_text = true },
                output = { open_on_run = true },
            })
        end,
        keys = {
            {
                "<leader>tt",
                function()
                    require("neotest").run.run(vim.fn.expand("%"))
                end,
                desc = "Run File",
            },
            {
                "<leader>tT",
                function()
                    require("neotest").run.run(vim.loop.cwd())
                end,
                desc = "Run All Test Files",
            },
            {
                "<leader>tr",
                function()
                    require("neotest").run.run()
                end,
                desc = "Run Nearest",
            },
            {
                "<leader>td",
                function()
                    require("neotest").run.run({ strategy = "dap" })
                end,
                desc = "Debug Nearest",
            },
            {
                "<leader>ts",
                function()
                    require("neotest").summary.toggle()
                end,
                desc = "Toggle Summary",
            },
            {
                "<leader>to",
                function()
                    require("neotest").output.open({
                        enter = true,
                        auto_close = true,
                    })
                end,
                desc = "Show Output",
            },
            {
                "<leader>tO",
                function()
                    require("neotest").output_panel.toggle()
                end,
                desc = "Toggle Output Panel",
            },
            {
                "<leader>tS",
                function()
                    require("neotest").run.stop()
                end,
                desc = "Stop",
            },
        },
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            {
                "williamboman/mason.nvim",
                opts = { ensure_installed = { "java-debug-adapter", "java-test" } },
            },
            {
                "mfussenegger/nvim-dap-python",
                keys = {
                    {
                        "<leader>dPt",
                        function()
                            require("dap-python").test_method()
                        end,
                        desc = "Debug Method",
                    },
                    {
                        "<leader>dPc",
                        function()
                            require("dap-python").test_class()
                        end,
                        desc = "Debug Class",
                    },
                },
                config = function()
                    local path = require("mason-registry").get_package("debugpy"):get_install_path()
                    require("dap-python").setup(path .. "/venv/bin/python")
                end,
            },
            { "theHamsta/nvim-dap-virtual-text", opts = {} },
            {
                "folke/which-key.nvim",
                optional = true,
                opts = {
                    defaults = {
                        ["<leader>d"] = { name = "+debug" },
                        ["<leader>da"] = { name = "+adapters" },
                    },
                },
            },
            {
                "rcarriga/nvim-dap-ui",
                keys = {
                    {
                        "<leader>du",
                        function()
                            require("dapui").toggle({})
                        end,
                        desc = "Dap UI",
                    },
                    {
                        "<leader>de",
                        function()
                            require("dapui").eval()
                        end,
                        desc = "Eval",
                        mode = { "n", "v" },
                    },
                },
                opts = {},
                config = function(_, opts)
                    local dap = require("dap")
                    local dapui = require("dapui")
                    dapui.setup(opts)
                    dap.listeners.after.event_initialized["dapui_config"] = function()
                        dapui.open({})
                    end
                    dap.listeners.before.event_terminated["dapui_config"] = function()
                        dapui.close({})
                    end
                    dap.listeners.before.event_exited["dapui_config"] = function()
                        dapui.close({})
                    end
                end,
            },
            {
                "jay-babu/mason-nvim-dap.nvim",
                dependencies = { { "mason.nvim" } },
                cmd = { "DapInstall", "DapUninstall" },
                opts = {
                    automatic_installation = true,
                    -- see mason-nvim-dap README for more information
                    handlers = {},
                    ensure_installed = {
                        "python",
                    },
                },
            },
        },
        -- config = function()
        --     local dap = require('dap')
        --     -- Configure Java DAP
        --     dap.configurations.java = {
        --         {
        --             type = 'java',
        --             request = 'launch',
        --             name = "Launch Java Program",
        --             mainClass = "${file}",
        --             projectName = "${workspaceFolder}",
        --             vmArgs = "",
        --         }
        --     }
        -- end,
        keys = {
            {
                "<leader>dB",
                function()
                    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
                end,
                desc = "Breakpoint Condition",
            },
            {
                "<leader>db",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "Toggle Breakpoint",
            },
            {
                "<leader>dc",
                function()
                    require("dap").continue()
                end,
                desc = "Continue",
            },
            {
                "<leader>dC",
                function()
                    require("dap").run_to_cursor()
                end,
                desc = "Run to Cursor",
            },
            {
                "<leader>dg",
                function()
                    require("dap").goto_()
                end,
                desc = "Go to line (no execute)",
            },
            {
                "<leader>di",
                function()
                    require("dap").step_into()
                end,
                desc = "Step Into",
            },
            {
                "<leader>dj",
                function()
                    require("dap").down()
                end,
                desc = "Down",
            },
            {
                "<leader>dk",
                function()
                    require("dap").up()
                end,
                desc = "Up",
            },
            {
                "<leader>dl",
                function()
                    require("dap").run_last()
                end,
                desc = "Run Last",
            },
            {
                "<leader>do",
                function()
                    require("dap").step_out()
                end,
                desc = "Step Out",
            },
            {
                "<leader>dO",
                function()
                    require("dap").step_over()
                end,
                desc = "Step Over",
            },
            {
                "<leader>dp",
                function()
                    require("dap").pause()
                end,
                desc = "Pause",
            },
            {
                "<leader>dr",
                function()
                    require("dap").repl.toggle()
                end,
                desc = "Toggle REPL",
            },
            {
                "<leader>ds",
                function()
                    require("dap").session()
                end,
                desc = "Session",
            },
            {
                "<leader>dt",
                function()
                    require("dap").terminate()
                end,
                desc = "Terminate",
            },
            {
                "<leader>dw",
                function()
                    require("dap.ui.widgets").hover()
                end,
                desc = "Widgets",
            },
        },
    },
}
