local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    print("Installing packer close and reopen Neovim...")
    vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
    },
})

-- Install your plugins here
return packer.startup(function(use)
    use({ "wbthomason/packer.nvim", commit = "00ec5ad" })
    use({ "nvim-lua/popup.nvim", commit = "b7404d3" })
    use({ "nvim-lua/plenary.nvim", commit = "968a4b9" })
    use({ "windwp/nvim-autopairs", commit = "fa6876f" })
    use({ "kylechui/nvim-surround", commit = "beea0fd" })
    use({ "numToStr/Comment.nvim", commit = "2c26a00" })
    use({ "kyazdani42/nvim-web-devicons", commit = "8d2c533" })
    use({ "kyazdani42/nvim-tree.lua", commit = "bdb6d4a" })
    use({ "akinsho/bufferline.nvim", commit = "c78b3ec" })
    use({ "moll/vim-bbye", commit = "25ef93a" })
    use({ "akinsho/toggleterm.nvim", commit = "aaeed9e" })
    use({ "ahmedkhalf/project.nvim", commit = "541115e" })
    use({ "lewis6991/impatient.nvim", commit = "969f2c5" })
    use({ "lukas-reineke/indent-blankline.nvim", commit = "6177a59" })
    use({ "antoinemadec/FixCursorHold.nvim", commit = "1bfb32e" }) -- This is needed to fix lsp doc highlight
    use({ "folke/which-key.nvim", commit = "bd4411a" })
    use({ "nvim-lualine/lualine.nvim", commit = "3362b28" })
    use({ "goolord/alpha-nvim", commit = "ef27a59" })
    use({ "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons", commit = "da61737" })
    use({ 'smithbm2316/centerpad.nvim', commit = "666641d" })
    use({ "Pocco81/AutoSave.nvim", commit = "3d342d6" })

    -- Colorschemes
    -- use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
    use({ "catppuccin/nvim", as = "catppuccin", commit = "773d339" })
    use({ "lunarvim/darkplus.nvim", commit = "93fb1fd" })

    -- cmp plugins
    use({ "hrsh7th/nvim-cmp", commit = "9897465" }) -- The completion plugin
    use({ "hrsh7th/cmp-buffer", commit = "62fc67a" }) -- buffer completions
    use({ "hrsh7th/cmp-path", commit = "981baf9" }) -- path completions
    use({ "hrsh7th/cmp-cmdline", commit = "c36ca4b" }) -- cmdline completions
    use({ "saadparwaiz1/cmp_luasnip", commit = "a9de941" }) -- snippet completions
    use({ "hrsh7th/cmp-nvim-lsp", commit = "affe808" })
    use({ "hrsh7th/cmp-nvim-lua", commit = "d276254" })
    use({ "ray-x/lsp_signature.nvim", commit = "3694c1f" })

    -- snippets
    use({ "L3MON4D3/LuaSnip", commit = "7d78278" })
    use({ "rafamadriz/friendly-snippets", commit = "0e516c9" })

    -- LSP
    use({ "neovim/nvim-lspconfig", commit = "41a8269" }) -- enable LSP
    use({ "williamboman/nvim-lsp-installer", commit = "d6d564b" }) -- simple to use language server installer
    use({ "jose-elias-alvarez/null-ls.nvim", commit = "c9348b4" }) -- for formatters and linters
    use({
        "ThePrimeagen/refactoring.nvim",
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-treesitter/nvim-treesitter" }
        },
        commit = "7328413"
    })
    use({ "python-rope/ropevim", run = "pip install ropevim", disable = false, commit = "230f0ed" })

    -- Telescope
    use("nvim-telescope/telescope.nvim")
    use("nvim-telescope/telescope-media-files.nvim")

    -- Treesitter
    use({
        "nvim-treesitter/nvim-treesitter",
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
        commit = "91725df"
    })
    use({ "JoosepAlviste/nvim-ts-context-commentstring", commit = "8834375" })
    use({ "p00f/nvim-ts-rainbow", commit = "6c0b3b6" })
    use({"nvim-treesitter/playground", commit = "ce7e4b7"})
    use({ "yioneko/nvim-yati", requires = "nvim-treesitter/nvim-treesitter", commit = "d3a898e" })

    -- Git
    use({ "kdheepak/lazygit.nvim", commit = "9c73fd6" })
    use({"lewis6991/gitsigns.nvim", commit = "bb6c3bf"})

    -- Debugging
    use({ "mfussenegger/nvim-dap", commit = "014ebd5" })
    use({ "rcarriga/nvim-dap-ui", commit = "52f4840" })
    use({ "ravenxrz/DAPInstall.nvim", commit = "8798b4c" })
    use("theHamsta/nvim-dap-virtual-text")
    use("nvim-telescope/telescope-dap.nvim")

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
