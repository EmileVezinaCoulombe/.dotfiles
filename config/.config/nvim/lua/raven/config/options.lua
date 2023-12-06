-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- :help options
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local options = {
    autowrite = true, -- Enable auto write
    clipboard = "unnamedplus", -- Sync with system clipboard
    completeopt = "menu,menuone,noselect", -- mostly just for cmp
    conceallevel = 0, -- so that `` is visible in markdown files
    confirm = true, -- Confirm to save changes before exiting modified buffer
    cursorline = true, -- Enable highlighting of the current line
    expandtab = true, -- Use spaces instead of tabs
    formatoptions = "jcroqlnt", -- tcqj
    grepformat = "%f:%l:%c:%m",
    grepprg = "rg --vimgrep",
    inccommand = "nosplit", -- preview incremental substitute
    laststatus = 0,
    list = true, -- Show some invisible characters (tabs...
    mouse = "a", -- Enable mouse mode
    pumblend = 10, -- Popup blend
    pumheight = 10, -- Maximum number of entries in a popup
    relativenumber = true, -- Relative line numbers
    sessionoptions = {"buffers", "curdir", "tabpages", "winsize"},
    shiftround = true, -- Round indent
    showmode = true, -- Show mode since we have a statusline
    splitbelow = true, -- Put new windows below current
    splitright = true, -- Put new windows right of current
    wildmode = "longest:full,full", -- Command-line completion mode
    winminwidth = 5, -- Minimum window width
    spelllang = "en,fr",
    spell = true,
    nrformats = "bin,alpha,hex,octal",
    cmdheight = 1, -- 0 bug ? Want more screen!!
    foldenable = false,
    foldmethod = "indent",
    foldlevel = 99,
    backup = false, -- creates a backup file
    fileencoding = "utf-8", -- the encoding written to a file
    hlsearch = true, -- highlight all matches on previous search pattern
    ignorecase = true, -- ignore case in search patterns
    showtabline = 2, -- always show tabs
    smartcase = true, -- smart case. Don't ignore case with capitals
    smartindent = true, -- Insert indents automatically
    swapfile = false, -- creates a swapfile
    termguicolors = true, -- set term gui colors (most terminals support this)
    timeoutlen = 250, -- time to wait for a mapped sequence to complete (in milliseconds)
    ttimeoutlen = 10,
    undofile = true, -- enable persistent undo
    updatetime = 200, -- Save swap file and trigger CursorHold (4000ms default)
    writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
    shiftwidth = 4, -- Size of an indentation
    tabstop = 4, -- insert n spaces for a table
    number = true, -- set numbered lines
    numberwidth = 4, -- set number column width to 2 {default 4}
    signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
    colorcolumn = "80",
    wrap = false, -- display lines as one long line
    scrolloff = 8, -- Lines of context
    sidescrolloff = 8, -- Columns of context
    guifont = "monospace:h17" -- the font used in graphical neovim applications
}

local local_options = {foldenable = true}

for k, v in pairs(options) do vim.opt[k] = v end

for k, v in pairs(local_options) do vim.opt_local[k] = v end

vim.opt.shortmess:append({W = true, I = true, c = true})
