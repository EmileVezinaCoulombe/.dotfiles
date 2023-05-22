return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      -- opts.default_timeout = 500000
      opts.sources = vim.list_extend(opts.sources, {
        nls.builtins.diagnostics.markdownlint,
        nls.builtins.diagnostics.selene.with({
          condition = function(utils)
            return utils.root_has_file({ "selene.toml" })
          end,
        }),
        nls.builtins.formatting.isort,
        nls.builtins.formatting.black,
        nls.builtins.formatting.autoflake.with({
          extra_args = {
            "--remove-unused-variables",
            "--remove-all-unused-imports",
          },
        }),
        nls.builtins.diagnostics.ruff,
        nls.builtins.diagnostics.mypy.with({
          extra_args = {
            "--python-executable",
            require("utils.python_path").venv_python_path,
          },
        }),
        nls.builtins.formatting.stylua.with({
          condition = function(utils)
            return utils.root_has_file({ "stylua.toml" })
          end,
        }),
        nls.builtins.diagnostics.luacheck.with({
          condition = function(utils)
            return utils.root_has_file({ ".luacheckrc" })
          end,
        }),
      })
    end,
  },
}
