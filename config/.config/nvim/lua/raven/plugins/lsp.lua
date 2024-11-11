return {
    {
        -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true },
    {
        "hrsh7th/nvim-cmp",
        version = false, -- last release is way too old
        event = "InsertEnter",
        dependencies = {
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },
            { "SergioRibera/cmp-dotenv" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-emoji" },
            { "petertriho/cmp-git" },
            { "hrsh7th/cmp-nvim-lua" },
            { "Saecki/crates.nvim" },
            { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
        },
        -- opts = { sources = { name = "crates" } },
        opts = function()
            -- vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
            local cmp = require("cmp")
            local defaults = require("cmp.config.default")()

            return {
                sorting = defaults.sorting,
                default_timeout = 500,
                experimental = {
                    -- ghost_text = {
                    --     hl_group = "CmpGhostText",
                    -- },
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                auto_brackets = {}, -- configure any filetype to auto add brackets
                -- completion = {
                --     completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
                -- },
                -- preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
                mapping = cmp.mapping.preset.insert({
                    ["<Down>"] = cmp.mapping.select_next_item({
                        behavior = cmp.SelectBehavior.Insert,
                    }),
                    ["<Up>"] = cmp.mapping.select_prev_item({
                        behavior = cmp.SelectBehavior.Insert,
                    }),
                    -- ["<tab>"] = cmp.mapping.complete(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept explicitly selected item.
                    -- ["<Tab>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ["<S-Tab>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ["<C-e>"] = cmp.mapping.abort(),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "path" },
                    { name = "luasnip" },
                    -- { name = "nvim_lsp:tailwindcss" },
                }, {
                    { name = "buffer" },
                    { name = "crates" },
                    { name = "dotenv" },
                    { name = "emoji" },
                    -- { name = "git" },
                }),
            }
        end,
    },
    {
        "j-hui/fidget.nvim",
        opts = {},
    },
    {
        "neovim/nvim-lspconfig",
        cmd = { "LspInfo", "LspInstall", "LspStart" },
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
            { "jose-elias-alvarez/typescript.nvim" },
            { "j-hui/fidget.nvim" },
            { "hrsh7th/cmp-nvim-lsp" },
        },
        ---@class PluginLspOpts
        opts = {
            ---@type lspconfig.options
            servers = {
                -- biome = {},
                tailwindcss = {},
                tsserver = {
                    keys = {
                        { "<leader>co", "<cmd>TypescriptOrganizeImports<CR>", desc = "Organize Imports" },
                        { "<leader>cR", "<cmd>TypescriptRenameFile<CR>",      desc = "Rename File" },
                    },
                },
                eslint = {
                    settings = {
                        -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
                        workingDirectory = { mode = "auto" },
                    },
                },
                jdtls = false,
            },
        },
        ---@param opts PluginLspOpts
        config = function(_, opts)
            -- This is where all the LSP shenanigans live
            local set_autoformat = function(pattern, bool_val)
                vim.api.nvim_create_autocmd({ "FileType" }, {
                    pattern = pattern,
                    callback = function()
                        vim.b.autoformat = bool_val
                    end,
                })
            end

            set_autoformat({ "java" }, false)

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("raven-lsp-attach", { clear = true }),
                callback = function(event)
                    local function map(mode, lhs, rhs, k_opts)
                        vim.keymap.set(
                            mode,
                            lhs,
                            rhs,
                            vim.tbl_extend("force", { buffer = bufnr, remap = false }, k_opts)
                        )
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

                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    -- local client = vim.lsp.get_client_by_id(event.data.client_id)
                    -- if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                    --     local highlight_augroup = vim.api.nvim_create_augroup("raven-lsp-highlight", { clear = false })
                    --     vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                    --         buffer = event.buf,
                    --         group = highlight_augroup,
                    --         callback = vim.lsp.buf.document_highlight,
                    --     })
                    --
                    --     vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                    --         buffer = event.buf,
                    --         group = highlight_augroup,
                    --         callback = vim.lsp.buf.clear_references,
                    --     })
                    --
                    --     vim.api.nvim_create_autocmd("LspDetach", {
                    --         group = vim.api.nvim_create_augroup("raven-lsp-detach", { clear = true }),
                    --         callback = function(event2)
                    --             vim.lsp.buf.clear_references()
                    --             vim.api.nvim_clear_autocmds({ group = "raven-lsp-highlight", buffer = event2.buf })
                    --         end,
                    --     })
                    -- end

                    -- The following code creates a keymap to toggle inlay hints in your
                    -- code, if the language server you are using supports them
                    --
                    -- This may be unwanted, since they displace some of your code
                    -- if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                    --     map("<leader>th", function()
                    --         vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                    --     end, "[T]oggle Inlay [H]ints")
                    -- end
                end,
            })
        end,
    }, -- formatters
    {
        "nvimtools/none-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "mason.nvim" },
        opts = function(_, opts)
            local nls = require("null-ls")

            opts.sources = vim.list_extend(opts.sources or {}, {
                -- Broken following none-ls switch
                -- nls.builtins.code_actions.shellcheck,
                -- nls.builtins.diagnostics.ruff,
                -- nls.builtins.diagnostics.shellcheck,
                -- nls.builtins.diagnostics.eslint,
                -- nls.builtins.diagnostics.luacheck.with({
                --     condition = function(utils)
                --         return utils.root_has_file({ ".luacheckrc" })
                --     end,
                -- }),

                -- code action
                require("typescript.extensions.null-ls.code-actions"),
                nls.builtins.code_actions.gitsigns,
                nls.builtins.code_actions.refactoring,
                -- diagnostics
                -- nls.builtins.diagnostics.ruff,
                nls.builtins.diagnostics.fish,
                nls.builtins.diagnostics.markdownlint,
                nls.builtins.diagnostics.selene.with({
                    condition = function(utils)
                        return utils.root_has_file({ "selene.toml" })
                    end,
                }),
                -- nls.builtins.diagnostics.mypy.with({
                --     extra_args = {
                --         "--python-executable",
                --         require("raven.utils").venv_python_path,
                --     },
                -- }),
                nls.builtins.diagnostics.sqlfluff.with({
                    extra_args = { "--dialect", "postgres" },
                }),
                -- formatting
                -- nls.builtins.formatting.biome.with({
                --     filetypes = {
                --         "javascript",
                --         "javascriptreact",
                --         "json",
                --         "jsonc",
                --         "typescript",
                --         "typescriptreact",
                --         "css",
                --     },
                --     args = {
                --         "check",
                --         "--write",
                --         "--unsafe",
                --         "--formatter-enabled=true",
                --         "--organize-imports-enabled=true",
                --         "--skip-errors",
                --         "--stdin-file-path=$FILENAME",
                --     },
                -- }),
                nls.builtins.formatting.prettierd,
                nls.builtins.formatting.fish_indent,
                nls.builtins.formatting.shfmt,
                nls.builtins.formatting.stylua,
                -- nls.builtins.formatting.ruff,
                nls.builtins.formatting.sql_formatter.with({
                    extra_args = { "--config", '{"tabWidth": 4}' },
                }),
                -- nls.builtins.formatting.rustfmt,
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
            })
            opts.should_attach = function(bufnr)
                -- Get filetype of the buffer
                local ft = vim.bo[bufnr].filetype
                -- Get the full path of the buffer
                local fname = vim.api.nvim_buf_get_name(bufnr)

                -- Don't attach to Java files or files in Java projects
                return ft ~= "java" and not vim.fn.filereadable(vim.fn.getcwd() .. "/pom.xml")
            end

            opts.condition = function(utils)
                return utils.root_has_file(".null-ls-root")
                    and not utils.root_has_file("pom.xml")
                    and vim.bo.filetype ~= "java"
            end
            return opts
        end,
    },
    {
        "jay-babu/mason-null-ls.nvim",
        -- event = { "BufReadPre", "BufNewFile" },
        event = "VeryLazy",
        dependencies = {
            "williamboman/mason.nvim",
            "nvimtools/none-ls.nvim",
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",
    },
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
        build = ":MasonUpdate",
        config = function(_, opts)
            local conf = vim.tbl_deep_extend("keep", opts, {
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })

            require("mason").setup(conf)

            local cmp_lsp = require("cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities()
            )

            require("mason-null-ls").setup({
                automatic_installation = false,
                ensure_installed = {
                    "actionlint",
                    "stylua",
                    "shfmt",
                    "sqlfluff",
                    "markdownlint",
                    "selene",
                    "luacheck",
                    "shellcheck",
                    "rustfmt",
                    "ruff",
                    "autoflake",
                    "prettierd",
                    "sql_formatter",
                },
            })
            require("mason-lspconfig").setup({
                ensure_installed = {
                    -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
                    "bashls",
                    "cssls",
                    "eslint",
                    "html",
                    -- "biome",
                    "angularls",
                    "jsonls",
                    "lua_ls",
                    "powershell_es",
                    "pylsp",
                    "ruff",
                    "sqlls",
                    "tailwindcss",
                    "ts_ls",
                    "typst_lsp",
                    "yamlls",
                },
                handlers = {
                    function(server_name) -- default handler (optional)
                        require("lspconfig")[server_name].setup({
                            capabilities = capabilities,
                        })
                    end,

                    rust_analyzer = function()
                        require("lspconfig").rust_analyzer.setup({
                            cargo = {
                                allFeatures = true,
                                loadOutDirsFromCheck = true,
                                buildScripts = {
                                    enable = true,
                                },
                            },
                            checkOnSave = {
                                allFeatures = true,
                                command = "clippy",
                                extraArgs = { "--no-deps" },
                            },
                            procMacro = {
                                enable = true,
                                ignored = {
                                    ["async-trait"] = { "async_trait" },
                                    ["napi-derive"] = { "napi" },
                                    ["async-recursion"] = { "async_recursion" },
                                    leptos_macro = {
                                        "component",
                                        "server",
                                    },
                                },
                            },
                        })
                    end,
                    angularls = function()
                        require("lspconfig").angularls.setup({
                            capabilities = capabilities,
                            settings = {},
                        })
                    end,
                    sqlls = function()
                        require("lspconfig").sqlls.setup(require("raven.plugins.lsp-opts.sqlls"))
                    end,
                    lua_ls = function()
                        require("lspconfig").lua_ls.setup({
                            capabilities = capabilities,
                            settings = {},
                        })
                    end,
                    bashls = function()
                        require("lspconfig").bashls.setup({
                            filetypes = { "sh", "zsh" },
                        })
                    end,
                    yamlls = function()
                        require("lspconfig").yamlls.setup(require("raven.plugins.lsp-opts.yamlls"))
                    end,
                    jsonls = function()
                        require("lspconfig").jsonls.setup(require("raven.plugins.lsp-opts.jsonls"))
                    end,
                    -- pylsp = function()
                    --     require("lspconfig").pylsp.setup(require("raven.plugins.lsp-opts.pylsp"))
                    -- end,

                    -- biome = function()
                    --     require("lspconfig").biome.setup({
                    --         capabilities = capabilities,
                    --         settings = {},
                    --     })
                    -- end,
                    ruff = function()
                        require("lspconfig").ruff.setup({
                            capabilities = capabilities,
                            settings = {},
                        })
                    end,
                    tailwindcss = function()
                        require("lspconfig").tailwindcss.setup({
                            capabilities = capabilities,
                            filetypes = {
                                "css",
                                "scss",
                                "sass",
                                "postcss",
                                "html",
                                "javascript",
                                "javascriptreact",
                                "typescript",
                                "typescriptreact",
                                "svelte",
                                "vue",
                                "rust",
                                "rs",
                            },
                            init_options = {
                                userLanguages = {
                                    rust = "html",
                                },
                            },
                        })
                    end,
                    ts_ls = function()
                        require("lspconfig").ts_ls.setup({
                            single_file_support = false,
                            on_init = function(client)
                                client.server_capabilities.documentFormattingProvider = false
                                client.server_capabilities.documentFormattingRangeProvider = false
                            end,
                        })
                    end,
                    eslint = function()
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            callback = function(event)
                                local client = vim.lsp.get_active_clients({ bufnr = event.buf, name = "eslint" })[1]
                                if client then
                                    local diag = vim.diagnostic.get(
                                        event.buf,
                                        { namespace = vim.lsp.diagnostic.get_namespace(client.id) }
                                    )
                                    if #diag > 0 then
                                        vim.cmd("EslintFixAll")
                                    end
                                end
                            end,
                        })
                    end,
                    typst_lsp = function()
                        vim.filetype.add({ extension = { typ = "typst" } })

                        local root_dir = require("raven.utils").get_root()
                        local nvim_lsp = require("lspconfig")
                        nvim_lsp.typst_lsp.setup({
                            settings = {
                                exportPdf = "onSave",
                                serverPath = root_dir,
                            },
                            filetypes = { "typst", "typ" },
                            root_dir = nvim_lsp.util.root_pattern("main.typ", ".git", ".wakatime*"),
                            single_file_support = false,
                        })
                    end,
                },
            })
        end,
    },
    {
        "mfussenegger/nvim-jdtls",
        dependencies = { "folke/which-key.nvim", "mfussenegger/nvim-dap" },
        ft = { "java" },
        opts = function()
            local mason_registry = require("mason-registry")
            local lombok_jar = mason_registry.get_package("jdtls"):get_install_path() .. "/lombok.jar"

            local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
            local find_root_dir = require("lspconfig").util.root_pattern(unpack(root_markers))

            return {
                root_dir = function(fname)
                    return find_root_dir(fname)
                end,

                -- -- How to find the root dir for a given filename. The default comes from
                -- project_name = function(root_dir)
                --     return root_dir and vim.fs.basename(root_dir)
                -- end,
                --
                -- -- Where are the config and workspace dirs for a project?
                -- jdtls_config_dir = function(project_name)
                --     return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
                -- end,
                -- jdtls_workspace_dir = function(project_name)
                --     return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
                -- end,
                -- How to run jdtls. This can be overridden to a full java command-line
                -- if the Python wrapper script doesn't suffice.
                cmd = {
                    vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls"),
                },
                --       {
                --     vim.fn.exepath("jdtls"),
                --     string.format("--jvm-arg=-javaagent:%s", lombok_jar),
                -- },
                -- full_cmd = function(opts)
                --     local fname = vim.api.nvim_buf_get_name(0)
                --     local root_dir = opts.root_dir(fname)
                --     local project_name = opts.project_name(root_dir)
                --     local cmd = vim.deepcopy(opts.cmd)
                --     if project_name then
                --         vim.list_extend(cmd, {
                --             "-configuration",
                --             opts.jdtls_config_dir(project_name),
                --             "-data",
                --             opts.jdtls_workspace_dir(project_name),
                --         })
                --     end
                --     return cmd
                -- end,

                -- These depend on nvim-dap, but can additionally be disabled by setting false here.
                -- dap = { hotcodereplace = "auto", config_overrides = {} },
                -- dap_main = {},
                -- test = true,
                settings = {
                    java = {
                        format = {
                            enabled = false,
                        },
                        saveActions = {
                            organizeImports = false,
                        },
                        inlayHints = {
                            parameterNames = {
                                enabled = "all",
                            },
                        },
                        configuration = {
                            updateBuildConfiguration = "automatic",
                            runtimes = {
                                {
                                    name = "JavaSE-21",
                                    path = "/home/emile/.sdkman/candidates/java/current",
                                    default = true,
                                },
                            },
                        },
                        init_options = {
                            bundles = {},
                            extendedClientCapabilities = {
                                progressReportProvider = false
                            }
                        },
                        flags = {
                            allow_incremental_sync = true,
                        },
                    },
                },
                -- on_attach = function(client, bufnr)
                --     -- Clear any existing formatting autocmds for this buffer
                --     vim.api.nvim_clear_autocmds({
                --         group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
                --         buffer = bufnr
                --     })
                --
                --     -- Disable the formatting provider
                --     client.server_capabilities.documentFormattingProvider = false
                --     client.server_capabilities.documentRangeFormattingProvider = false
                --
                --     -- Add an empty autocmd to prevent other formatting autocmds
                --     vim.api.nvim_create_autocmd("BufWritePre", {
                --         group = vim.api.nvim_create_augroup("LspFormatting", { clear = false }),
                --         buffer = bufnr,
                --         callback = function()
                --             -- Do nothing on save
                --         end,
                --     })
                -- end
            }
        end,
        config = function(_, opts)
            -- vim.api.nvim_create_autocmd("FileType", {
            --     pattern = "java",
            --     callback = function()
            --         -- Disable autosave for Java files
            --         vim.b.auto_save = false
            --     end
            -- })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "java",
                callback = function()
                    vim.b.format_on_save = false -- Disable format on save
                end,
            })
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.java",
                callback = function()
                    -- Add a small delay before formatting
                    vim.defer_fn(function()
                        vim.lsp.buf.format({ async = false })
                    end, 100)
                end,
            })
            local function attach_jdtls()
                require("jdtls").start_or_attach(opts)
            end

            attach_jdtls()
        end,
    },
    -- {
    --     "mfussenegger/nvim-jdtls",
    --     dependencies = { "folke/which-key.nvim", "mfussenegger/nvim-dap" },
    --     ft = { "java" },
    --     opts = function()
    --         local mason_registry = require("mason-registry")
    --         local lombok_jar = mason_registry.get_package("jdtls"):get_install_path() .. "/lombok.jar"
    --
    --         local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
    --         local find_root_dir = require("lspconfig").util.root_pattern(unpack(root_markers))
    --
    --         return {
    --             root_dir = function(fname)
    --                 return find_root_dir(fname)
    --             end,
    --
    --             -- How to find the root dir for a given filename. The default comes from
    --             project_name = function(root_dir)
    --                 return root_dir and vim.fs.basename(root_dir)
    --             end,
    --
    --             -- Where are the config and workspace dirs for a project?
    --             jdtls_config_dir = function(project_name)
    --                 return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
    --             end,
    --             jdtls_workspace_dir = function(project_name)
    --                 return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
    --             end,
    --             -- How to run jdtls. This can be overridden to a full java command-line
    --             -- if the Python wrapper script doesn't suffice.
    --             cmd = {
    --                 vim.fn.exepath("jdtls"),
    --                 string.format("--jvm-arg=-javaagent:%s", lombok_jar),
    --             },
    --             full_cmd = function(opts)
    --                 local fname = vim.api.nvim_buf_get_name(0)
    --                 local root_dir = opts.root_dir(fname)
    --                 local project_name = opts.project_name(root_dir)
    --                 local cmd = vim.deepcopy(opts.cmd)
    --                 if project_name then
    --                     vim.list_extend(cmd, {
    --                         "-configuration",
    --                         opts.jdtls_config_dir(project_name),
    --                         "-data",
    --                         opts.jdtls_workspace_dir(project_name),
    --                     })
    --                 end
    --                 return cmd
    --             end,
    --
    --             -- These depend on nvim-dap, but can additionally be disabled by setting false here.
    --             dap = { hotcodereplace = "auto", config_overrides = {} },
    --             dap_main = {},
    --             test = true,
    --             settings = {
    --                 java = {
    --                     format = {
    --                         enabled = false,
    --                     },
    --                     saveActions = {
    --                         organizeImports = false,
    --                     },
    --                     inlayHints = {
    --                         parameterNames = {
    --                             enabled = "all",
    --                         },
    --                     },
    --                     configuration = {
    --                         updateBuildConfiguration = "automatic",
    --                         runtimes = {
    --                             {
    --                                 name = "JavaSE-21",
    --                                 path = "/home/emile/.sdkman/candidates/java/current",
    --                                 default = true,
    --                             },
    --                         },
    --                     },
    --                 },
    --             },
    --             on_init = function(client)
    --                 client.server_capabilities.documentFormattingProvider = false
    --                 client.server_capabilities.documentRangeFormattingProvider = false
    --             end,
    --         }
    --     end,
    --     config = function(_, opts)
    --         -- Find the extra bundles that should be passed on the jdtls command-line
    --         -- if nvim-dap is enabled with java debug/test.
    --         local mason_registry = require("mason-registry")
    --         local bundles = {} ---@type string[]
    --         if opts.dap and mason_registry.is_installed("java-debug-adapter") then
    --             local java_dbg_pkg = mason_registry.get_package("java-debug-adapter")
    --             local java_dbg_path = java_dbg_pkg:get_install_path()
    --             local jar_patterns = {
    --                 java_dbg_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
    --             }
    --             -- java-test also depends on java-debug-adapter.
    --             if opts.test and mason_registry.is_installed("java-test") then
    --                 local java_test_pkg = mason_registry.get_package("java-test")
    --                 local java_test_path = java_test_pkg:get_install_path()
    --                 vim.list_extend(jar_patterns, {
    --                     java_test_path .. "/extension/server/*.jar",
    --                 })
    --             end
    --             for _, jar_pattern in ipairs(jar_patterns) do
    --                 for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), "\n")) do
    --                     table.insert(bundles, bundle)
    --                 end
    --             end
    --         end
    --
    --         local function attach_jdtls()
    --             local fname = vim.api.nvim_buf_get_name(0)
    --
    --             -- Configuration can be augmented and overridden by opts.jdtls
    --             local config = vim.tbl_deep_extend("force", {
    --                 cmd = opts.full_cmd(opts),
    --                 root_dir = opts.root_dir(fname),
    --                 init_options = {
    --                     bundles = bundles,
    --                 },
    --                 settings = opts.settings,
    --                 capabilities = require("cmp_nvim_lsp").default_capabilities(),
    --                 on_init = function(client)
    --                     client.server_capabilities.documentFormattingProvider = false
    --                     client.server_capabilities.documentRangeFormattingProvider = false
    --                 end,
    --                 on_attach = function(client, bufnr)
    --                     -- Disable formatting from one source
    --                     client.server_capabilities.documentFormattingProvider = false
    --                     -- Or explicitly set which one you want to use
    --                     vim.bo[bufnr].formatprg = "jdtls" -- or whatever formatter you prefer
    --                 end,
    --             }, {})
    --
    --             -- Existing server will be reused if the root_dir matches.
    --             require("jdtls").start_or_attach(config)
    --             -- not need to require("jdtls.setup").add_commands(), start automatically adds commands
    --         end
    --
    --         -- Attach the jdtls for each java buffer. HOWEVER, this plugin loads
    --         -- depending on filetype, so this autocmd doesn't run for the first file.
    --         -- For that, we call directly below.
    --         --
    --         vim.api.nvim_create_autocmd("BufWritePre", {
    --             pattern = "*.java",
    --             callback = function()
    --                 print("Formatter used:", vim.bo.formatprg)
    --                 print("Format options:", vim.inspect(vim.b.format_options))
    --             end,
    --         })
    --         vim.api.nvim_create_autocmd("FileType", {
    --             pattern = "java",
    --             callback = function()
    --                 vim.b.autoformat = false
    --             end,
    --         })
    --         vim.api.nvim_create_autocmd("FileType", {
    --             pattern = "java",
    --             callback = attach_jdtls,
    --         })
    --
    --         -- Setup keymap and dap after the lsp is fully attached.
    --         -- https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration
    --         -- https://neovim.io/doc/user/lsp.html#LspAttach
    --         vim.api.nvim_create_autocmd("LspAttach", {
    --             callback = function(args)
    --                 local client = vim.lsp.get_client_by_id(args.data.client_id)
    --                 if client and client.name == "jdtls" then
    --                     local wk = require("which-key")
    --                     wk.add({
    --                         {
    --                             mode = "n",
    --                             buffer = args.buf,
    --                             { "<leader>cx", group = "extract" },
    --                             { "<leader>cxv", require("jdtls").extract_variable_all, desc = "Extract Variable" },
    --                             { "<leader>cxc", require("jdtls").extract_constant, desc = "Extract Constant" },
    --                             { "gs", require("jdtls").super_implementation, desc = "Goto Super" },
    --                             { "gS", require("jdtls.tests").goto_subjects, desc = "Goto Subjects" },
    --                             { "<leader>co", require("jdtls").organize_imports, desc = "Organize Imports" },
    --                         },
    --                     })
    --                     wk.add({
    --                         {
    --                             mode = "v",
    --                             buffer = args.buf,
    --                             { "<leader>cx", group = "extract" },
    --                             {
    --                                 "<leader>cxm",
    --                                 [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
    --                                 desc = "Extract Method",
    --                             },
    --                             {
    --                                 "<leader>cxv",
    --                                 [[<ESC><CMD>lua require('jdtls').extract_variable_all(true)<CR>]],
    --                                 desc = "Extract Variable",
    --                             },
    --                             {
    --                                 "<leader>cxc",
    --                                 [[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]],
    --                                 desc = "Extract Constant",
    --                             },
    --                         },
    --                     })
    --
    --                     if opts.dap and mason_registry.is_installed("java-debug-adapter") then
    --                         -- custom init for Java debugger
    --                         vim.defer_fn(function()
    --                             require("jdtls").setup_dap(opts.dap)
    --                             if opts.dap_main then
    --                                 require("jdtls.dap").setup_dap_main_class_configs(opts.dap_main)
    --                             end
    --                         end, 1000)
    --
    --                         -- Java Test require Java debugger to work
    --                         if opts.test and mason_registry.is_installed("java-test") then
    --                             -- custom keymaps for Java test runner (not yet compatible with neotest)
    --                             wk.add({
    --                                 {
    --                                     mode = "n",
    --                                     buffer = args.buf,
    --                                     { "<leader>t", group = "test" },
    --                                     {
    --                                         "<leader>tt",
    --                                         function()
    --                                             require("jdtls.dap").test_class({
    --                                                 config_overrides = type(opts.test) ~= "boolean"
    --                                                         and opts.test.config_overrides
    --                                                     or nil,
    --                                             })
    --                                         end,
    --                                         desc = "Run All Test",
    --                                     },
    --                                     {
    --                                         "<leader>tr",
    --                                         function()
    --                                             require("jdtls.dap").test_nearest_method({
    --                                                 config_overrides = type(opts.test) ~= "boolean"
    --                                                         and opts.test.config_overrides
    --                                                     or nil,
    --                                             })
    --                                         end,
    --                                         desc = "Run Nearest Test",
    --                                     },
    --                                     { "<leader>tT", require("jdtls.dap").pick_test, desc = "Run Test" },
    --                                 },
    --                             })
    --                         end
    --                     end
    --
    --                     -- User can set additional keymaps in opts.on_attach
    --                     if opts.on_attach then
    --                         opts.on_attach(args)
    --                     end
    --                 end
    --             end,
    --         })
    --
    --         -- Avoid race condition by calling attach the first time, since the autocmd won't fire.
    --         attach_jdtls()
    --     end,
    -- },
}
