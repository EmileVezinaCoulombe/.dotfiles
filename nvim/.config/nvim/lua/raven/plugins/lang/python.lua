return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "ninja", "python", "rst", "toml"})
        end,
    },
    {
        "nvim-neotest/neotest",
        optional = true,
        dependencies = { "nvim-neotest/neotest-python" },
        opts = {
            adapters = {
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
        },
    },
    {
        "mfussenegger/nvim-dap",
        optional = true,
        dependencies = {
            "mfussenegger/nvim-dap-python",
            -- stylua: ignore
            keys = {
                {
                    "<leader>dPt",
                    function()
                        require('dap-python').test_method()
                    end,
                    desc = "Debug Method"
                }, {
                    "<leader>dPc",
                    function()
                        require('dap-python').test_class()
                    end,
                    desc = "Debug Class"
                }
            },
            config = function()
                local path = require("mason-registry").get_package("debugpy"):get_install_path()
                require("dap-python").setup(path .. "/venv/bin/python")
            end,
        },
    },
    {
        "linux-cultist/venv-selector.nvim",
        cmd = "VenvSelect",
        opts = { name = { "venv", ".venv", "env", ".env" } },
        keys = {
            { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv" },
        },
    },
}
