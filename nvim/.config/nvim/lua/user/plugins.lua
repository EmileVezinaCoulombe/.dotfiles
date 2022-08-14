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
    snapshot = "ice",
    snapshot_path = fn.stdpath "config" .. "/snapshots",
    max_jobs = 50,
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
        prompt_border = "rounded",
    },
})

-- Install your plugins here
return packer.startup(function(use)
    use({ "wbthomason/packer.nvim" })
    use({ "nvim-lua/popup.nvim" })
    use({ "nvim-lua/plenary.nvim" })
    use({ "windwp/nvim-autopairs" })
    use({ "numToStr/Comment.nvim" })
    use({ "kyazdani42/nvim-tree.lua" })
    use({ "akinsho/bufferline.nvim" })
    use({ "moll/vim-bbye" })
    use({ "akinsho/toggleterm.nvim" })
    use({ "ahmedkhalf/project.nvim" })
    use({ "lewis6991/impatient.nvim" })
    use({ "lukas-reineke/indent-blankline.nvim" })
    use({ "antoinemadec/FixCursorHold.nvim" }) -- This is needed to fix lsp doc highlight
    use({ "folke/which-key.nvim" })
    use({ "nvim-lualine/lualine.nvim" })
    use({ "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons" })

    --------------------------------------------------------------------------

    -- Plugin Manager

    -- LSP
    use({ "neovim/nvim-lspconfig" })
    use({ "williamboman/nvim-lsp-installer" })
    use({ "jose-elias-alvarez/null-ls.nvim" })
    use({ "ray-x/lsp_signature.nvim" })

    -- Completion
    use({ "hrsh7th/nvim-cmp" })
    use({ "hrsh7th/cmp-buffer" })
    use({ "hrsh7th/cmp-path" })
    use({ "hrsh7th/cmp-cmdline" })
    use({ "saadparwaiz1/cmp_luasnip" })
    use({ "hrsh7th/cmp-nvim-lsp" })
    use({ "hrsh7th/cmp-nvim-lua" })

    -- Markdown

    -- Syntax
    use({
        "nvim-treesitter/nvim-treesitter",
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end
    })
    use({ "nvim-treesitter/playground" })
    use({ "yioneko/nvim-yati", requires = "nvim-treesitter/nvim-treesitter" })
    use({ "kylechui/nvim-surround" })

    -- Terminal integration

    -- Snippet
    use({ "rafamadriz/friendly-snippets" })
    use({ "L3MON4D3/LuaSnip" })

    -- Register

    -- Marks

    -- Fuzzy Finder
    use({ "nvim-telescope/telescope.nvim" })
    use({
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    })

    -- Note Taking

    -- Color

    -- Colorscheme Creation

    -- Colorscheme
    use({ "catppuccin/nvim", as = "catppuccin" })
    use({ "folke/tokyonight.nvim" })
    use({ "rebelot/kanagawa.nvim" })

    -- Utility
    use({ "stevearc/dressing.nvim" })

    -- Icon
    use({ "kyazdani42/nvim-web-devicons" })
    use({ "ziontee113/icon-picker.nvim", config = function() require("icon-picker") end })
    -- Debugging
    use({ "mfussenegger/nvim-dap" })
    use({ "rcarriga/nvim-dap-ui" })
    use({ "ravenxrz/DAPInstall.nvim" })
    use({ "theHamsta/nvim-dap-virtual-text" })
    use({ "nvim-telescope/telescope-dap.nvim" })

    -- Spellcheck

    -- Neovim Lua Development

    -- Fennel

    -- Tabline

    -- Statusline

    -- Statusline component

    -- Cursorline

    -- Startup
    use({ "goolord/alpha-nvim" })

    -- Indent

    -- Game

    -- File explorer

    -- Dependency management

    -- Git
    use({ "lewis6991/gitsigns.nvim" })
    use({ "sindrets/diffview.nvim" })

    -- Programming languages support

    -- Comment

    -- Collaborative Editing

    -- Quickfix

    -- Motion

    -- Code Runner

    -- GitHub

    -- Search

    -- Scrollbar

    -- Scrolling

    -- Mouse

    -- Project

    -- Browser integration

    -- Editing support
    use({ "JoosepAlviste/nvim-ts-context-commentstring" })
    use({ "p00f/nvim-ts-rainbow" })
    use({
        "ThePrimeagen/refactoring.nvim",
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-treesitter/nvim-treesitter" }
        }
    })
    use({ "Pocco81/auto-save.nvim", branch = "dev" })
    use({ "python-rope/ropevim", run = "pip install ropevim", disable = false })

    -- Formatting

    -- Web development

    -- Media
    use({ "nvim-telescope/telescope-media-files.nvim" })

    -- Command Line

    -- Session

    -- Test

    -- Preconfigured Configuration

    -- Keybinding

    -- Tmux

    -- Remote Development

    -- Split and Window

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
