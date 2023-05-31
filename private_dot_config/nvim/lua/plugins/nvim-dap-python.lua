return {
  {
    "mfussenegger/nvim-dap-python",
    config = function(plugin, opts)
      local dap_python = require("dap-python")
      dap_python.setup(require("utils.python_path").mason_python_path)
      dap_python.test_runner = "unittest"
    end,
    opts = function(_, opts)
      local dap = require("dap")
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Debug python file",
          program = "${file}",
        },
      }
    end,
  },
}
