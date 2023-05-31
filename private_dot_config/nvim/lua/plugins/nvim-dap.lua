return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>dd",
        function()
          require("dap").terminate()
        end,
        desc = "Discard Session",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>dm",
        function()
          require("dap-python").test_method()
        end,
        desc = "Test method",
      },
      {
        "<leader>dT",
        function()
          require("dap-python").test_class()
        end,
        desc = "Test class",
      },
    },

    dependencies = {
      "mfussenegger/nvim-dap-python",
      dummy = true,
    },
  },
}
