local import_plugin = require("user.util").import_plugin

local ts_config = import_plugin("nvim-treesitter.configs")


ts_config.setup {
    ensure_installed = "all",
    auto_install = true,
    sync_install = false, -- Install languages synchronously (only applied to `ensure_installed`)
    ignore_install = { "" }, -- List of parsers to ignore installing
    autopairs = {
        enable = true,
    },
    highlight = {
        enable = true, -- false will disable the whole extension
        disable = { "" }, -- list of language that will be disabled
        additional_vim_regex_highlighting = true,
    },

    -- indent
    indent = { enable = true, disable = { "python", "yaml" } },
    yati = { enable = true },

    -- indent ruler
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
    },

    -- commentstring
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
}

-- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufAdd', 'BufNew', 'BufNewFile', 'BufWinEnter' }, {
    group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
    callback = function()
        vim.opt.foldmethod = 'expr'
        vim.opt.foldexpr   = 'nvim_treesitter#foldexpr()'
    end
})
