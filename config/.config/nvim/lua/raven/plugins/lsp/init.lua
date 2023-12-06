return {
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        lazy = true,
        config = false,
        dependencies = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },

            -- Autocompletion
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },

            -- Snippets
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },
        },
        init = function()
            -- Disable automatic setup, we are doing it manually
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    -- snippets
    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        dependencies = {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
        opts = { history = true, delete_check_events = "TextChanged" },
        keys = {
            {
                "<tab>",
                function()
                    return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
                end,
                expr = true,
                silent = true,
                mode = "i",
            },
            {
                "<tab>",
                function()
                    require("luasnip").jump(1)
                end,
                mode = "s",
            },
            {
                "<s-tab>",
                function()
                    require("luasnip").jump(-1)
                end,
                mode = { "i", "s" },
            },
        },
    }, -- auto completion
    {
        "hrsh7th/nvim-cmp",
        version = false, -- last release is way too old
        event = "InsertEnter",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-emoji",
            "petertriho/cmp-git",
        },
        opts = { sources = {}, sorting = { comparators = {} } },
        config = function()
            vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
            -- Here is where you configure the autocompletion settings.
            local lsp_zero = require("lsp-zero")
            lsp_zero.extend_cmp()

            -- And you can configure cmp even more, if you want to.
            local cmp = require("cmp")
            local cmp_action = lsp_zero.cmp_action()

            -- TODO: sources
            -- sources = cmp.config.sources({
            --     { name = "nvim_lsp", priority = 1000 },
            --     { name = "cmp-nvim-lua", priority = 900 },
            --     { name = "luasnip", priority = 750 },
            --     { name = "path", priority = 500 },
            --     { name = "buffer", priority = 250 },
            --     { name = "git", priority = 200 },
            --     { name = "emoji", priority = 200 },
            -- }),
            cmp.setup({
                sorting = {},
                default_timeout = 500,
                formatting = lsp_zero.cmp_format(),
                experimental = { ghost_text = { hl_group = "CmpGhostText" } },
                mapping = cmp.mapping.preset.insert({
                    -- Navigate
                    ["<Down>"] = cmp.mapping.select_next_item({
                        behavior = cmp.SelectBehavior.Insert,
                    }),
                    ["<Up>"] = cmp.mapping.select_prev_item({
                        behavior = cmp.SelectBehavior.Insert,
                    }),
                    ["<C-k>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-j>"] = cmp.mapping.scroll_docs(4),
                    ["<tab>"] = cmp_action.luasnip_jump_forward(),
                    ["<s-tab>"] = cmp_action.luasnip_jump_backward(),
                    -- Selection
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept explicitly selected item.
                    ["<Tab>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ["<S-Tab>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
            })
        end,
    },
    -- lspconfig
    {
        "neovim/nvim-lspconfig",
        cmd = { "LspInfo", "LspInstall", "LspStart" },
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
            { "hrsh7th/cmp-nvim-lsp" },
        },
        ---@class PluginLspOpts
        opts = {
            ---@type lspconfig.options
            servers = {
                jsonls = require("raven.plugins.lsp.opts.jsonls"),
            },
        },
        ---@param opts PluginLspOpts
        config = function(_, opts)
            -- This is where all the LSP shenanigans live
            local lsp_zero = require("lsp-zero")
            lsp_zero.extend_lspconfig()

            lsp_zero.on_attach(function(_, bufnr)
                -- see :help lsp-zero-keybindings to learn the available actions
                local function map(mode, lhs, rhs, k_opts)
                    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { buffer = bufnr, remap = false }, k_opts))
                end

                map("n", "<leader>cl", "<cmd>LspInfo<cr>", { desc = "Lsp Info" })
                map("n", "<C-f>", function()
                    vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
                end, { desc = "Format" })
                map("n", "<leader>cf", function()
                    vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
                end, { desc = "Format" })
                map("n", "gd", function()
                    vim.lsp.buf.definition()
                end, { desc = "Definition" })
                map("n", "K", function()
                    vim.lsp.buf.hover()
                end, { desc = "Hover" })
                map("n", "<leader>cw", function()
                    vim.lsp.buf.workspace_symbol()
                end, { desc = "Workspace symbol" })
                map("n", "<leader>cd", function()
                    vim.diagnostic.open_float()
                end, { desc = "Search diagnostic" })
                map("n", "]d", function()
                    vim.diagnostic.goto_next()
                end, { desc = "Next diagnostic" })
                map("n", "[d", function()
                    vim.diagnostic.goto_prev()
                end, { desc = "Previous diagnostic" })
                map("n", "<leader>ca", function()
                    vim.lsp.buf.code_action()
                end, { desc = "Code action" })
                map("n", "gr", function()
                    require("telescope.builtin").lsp_references({ reuse_win = true })
                    -- vim.lsp.buf.references({})
                end, { desc = "References" })
                map("n", "<leader>cr", function()
                    vim.lsp.buf.rename()
                end, { desc = "Rename" })
                map("i", "<C-h>", function()
                    vim.lsp.buf.signature_help()
                end, { desc = "Signature help" })
            end)
            require("mason").setup({})
            require("mason-lspconfig").setup({
                ensure_installed = {
                    -- TODO: move to the right places
                    -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
                    "yamlls",
                    "jsonls",
                    "angularls",
                    "powershell_es",
                    "tsserver",
                    "cssls",
                    "html",
                    "eslint",
                    "bashls",
                    "lua_ls",
                    "ruff_lsp",
                    "pylsp",
                    "jdtls",

                    -- "stylua",
                    -- "shfmt",
                    -- "markdownlint",
                    -- "selene",
                    -- "luacheck",
                    -- "shellcheck",
                    -- "black",
                    -- "isort",
                    -- "autoflake",
                    -- "mypy",
                    -- "prettierd",
                },
                handlers = {
                    lsp_zero.default_setup,
                    jdtls = lsp_zero.noop,
                    lua_ls = function()
                        local lua_opts = lsp_zero.nvim_lua_ls()
                        require("lspconfig").lua_ls.setup(lua_opts)
                    end,
                    bashls = function()
                        require("lspconfig").bashls.setup({
                            filetypes = { "sh", "zsh" },
                        })
                    end,
                    yamlls = function()
                        require("lspconfig").yamlls.setup(require("raven.plugins.lsp.opts.yamlls"))
                    end,
                    jsonls = function()
                        require("lspconfig").jsonls.setup(require("raven.plugins.lsp.opts.jsonls"))
                    end,
                    pylsp = function()
                        local py_opts = lsp_zero.default_setup()
                        require("lspconfig").pylsp.setup(require("raven.plugins.lsp.opts.pylsp"))
                    end,
                    ruff_lsp = function()
                        local ruff_opts = lsp_zero.default_setup()
                        require("lspconfig").ruff_lsp.setup({})
                    end,
                    tsserver = function()
                        require("lspconfig").tsserver.setup({
                            single_file_support = false,
                            on_init = function(client)
                                client.server_capabilities.documentFormattingProvider = false
                                client.server_capabilities.documentFormattingRangeProvider = false
                            end,
                        })
                    end,
                },
            })
        end,
    }, -- formatters
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "mason.nvim" },
        opts = function()
            local nls = require("null-ls")
            return {
                sources = {
                    -- code action
                    nls.builtins.code_actions.gitsigns,
                    nls.builtins.code_actions.shellcheck,
                    nls.builtins.code_actions.refactoring, -- diagnostics
                    nls.builtins.diagnostics.fish,
                    nls.builtins.diagnostics.ruff,
                    nls.builtins.diagnostics.markdownlint,
                    nls.builtins.diagnostics.shellcheck,
                    nls.builtins.diagnostics.eslint,
                    nls.builtins.diagnostics.luacheck.with({
                        condition = function(utils)
                            return utils.root_has_file({ ".luacheckrc" })
                        end,
                    }),
                    nls.builtins.diagnostics.selene.with({
                        condition = function(utils)
                            return utils.root_has_file({ "selene.toml" })
                        end,
                    }),
                    nls.builtins.diagnostics.mypy.with({
                        extra_args = {
                            "--python-executable",
                            require("raven.utils").venv_python_path,
                        },
                    }), -- formatting
                    nls.builtins.formatting.fish_indent,
                    nls.builtins.formatting.shfmt,
                    nls.builtins.formatting.stylua,
                    nls.builtins.formatting.beautysh,
                    nls.builtins.formatting.isort,
                    nls.builtins.formatting.black,
                    nls.builtins.formatting.prettierd,
                    nls.builtins.formatting.autoflake.with({
                        extra_args = {
                            "--remove-unused-variables",
                            "--remove-all-unused-imports",
                        },
                    }),
                    nls.builtins.formatting.csharpier.with({
                        condition = function(utils)
                            return utils.root_has_file({ ".csharpierrc.json" })
                        end,
                    }),
                    nls.builtins.formatting.stylua.with({
                        condition = function(utils)
                            return utils.root_has_file({ "stylua.toml" })
                        end,
                    }),
                },
            }
        end,
    }, -- cmdline tools and lsp servers
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
        build = ":MasonUpdate",
        opts = {
            ensure_installed = {},
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {},
        },
    },
}
