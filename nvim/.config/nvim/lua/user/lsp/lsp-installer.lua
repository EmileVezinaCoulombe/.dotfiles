local import_plugin = require("user.util").import_plugin

local lsp_installer = import_plugin( "nvim-lsp-installer")

lsp_installer.setup()

local servers = {
    "sumneko_lua",
    "cssls",
    "html",
    "tsserver",
    "pylsp",
    "pyright",
    "jedi_language_server",
    "bashls",
    "eslint",
    "jsonls",
    "yamlls",
}

local lspconfig = import_plugin( "lspconfig")

local on_attach = function(client, bufnr)
    require("user.lsp.handlers").on_attach(client, bufnr)
    require("aerial").on_attach(client, bufnr)
end



local opts = {}

for _, server in pairs(servers) do
    opts = {
        on_attach = on_attach,
        capabilities = require("user.lsp.handlers").capabilities,
    }

    if server == "jsonls" then
        local jsonls_opts = require("user.lsp.settings.jsonls")
        opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
    end

    if server == "sumneko_lua" then
        local sumneko_opts = require("user.lsp.settings.sumneko_lua")
        opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
    end

    if server == "pyright" then
        local pyright_opts = require("user.lsp.settings.pyright")
        opts = vim.tbl_deep_extend("force", pyright_opts, opts)
    end

    if server == "pylsp" then
        local pylsp_opts = require("user.lsp.settings.pylsp")
        opts = vim.tbl_deep_extend("force", pylsp_opts, opts)
    end

    if server == "jedi_language_server" then
        local jedi_opts = require("user.lsp.settings.jedi_language_server")
        opts = vim.tbl_deep_extend("force", jedi_opts, opts)
    end

    lspconfig[server].setup(opts)
end
