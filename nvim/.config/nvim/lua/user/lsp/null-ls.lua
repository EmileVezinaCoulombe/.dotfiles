local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
    return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/code_actions
local code_actions = null_ls.builtins.code_actions

null_ls.setup {
    debug = false,
    sources = {
        -- formatting
        formatting.prettier.with { extra_filetypes = { "toml", "solidity", "markdown" },
        },
        formatting.black,
        formatting.isort,
        formatting.stylua.with { extra_args = {"--indent_type Space"}},
        formatting.shfmt,
        formatting.google_java_format,

        -- diagnostics
        -- diagnostics.flake8,
        diagnostics.eslint,
        diagnostics.shellcheck,

        -- code actions
        code_actions.gitsigns,
        code_actions.shellcheck,
        code_actions.refactoring,

    },
}
