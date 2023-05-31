return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "angular-language-server",
        "powershell-editor-services",
        "markdownlint",
        "stylua",
        "selene",
        "stylua",
        "luacheck",
        "shellcheck",
        "shfmt",
        "black",
        "isort",
        "autoflake",
        "mypy",
        "typescript-language-server",
        "css-lsp",
        "html-lsp",
        "eslint-lsp",
        "prettierd",
        "csharp-language-server",
        "csharpier"
      })
    end,
  },
}
