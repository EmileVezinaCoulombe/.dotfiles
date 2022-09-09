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

local working_dir = function(params)
    return vim.fn.fnamemodify(params.bufname, ':h')
end

-- All null-ls built-in sources
-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
null_ls.setup {
    debug = false,
    sources = {
        -- formatting
        formatting.prettier.with { extra_filetypes = { "toml", "solidity", "markdown" },
        },
        formatting.black.with { cwd = working_dir },
        formatting.isort.with { cwd = working_dir },
        formatting.stylua.with { extra_args = { "--indent_type Space" } },
        formatting.shfmt,
        formatting.google_java_format,

        -- diagnostics
        -- diagnostics.flake8,
        -- diagnostics.pyproject_flake8,
        -- diagnostics.mypy.with { cwd = working_dir },
        -- diagnostics.pylint,
        diagnostics.pydocstyle.with { extra_args = { "--config=$ROOT/pyproject.toml" },
            diagnostics_postprocess = function(diagnostic)
                diagnostic.code = diagnostic.message_id
            end,
        },
        -- diagnostics.vulture,  -- finds unused code in Python programs.
        diagnostics.eslint,
        diagnostics.shellcheck,

        -- code actions
        code_actions.gitsigns,
        code_actions.shellcheck,
        code_actions.refactoring,

    },
}
