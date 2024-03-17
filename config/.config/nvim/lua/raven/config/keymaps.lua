-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
local Util = require("raven.utils")

local map = Util.map

-- Reload config
map({ "n" }, "<leader>$", "<cmd>source $MYVIMRC<CR>", { desc = "Reload Config", remap = false })

-- Warning
map({ "n" }, "<C-q>", "<cmd>qa<CR>", { desc = "Quit", remap = false })

-- Remove yank on delete

map({ "n", "v" }, "d", '"_d', { noremap = true, silent = true })
map({ "n", "v" }, "D", '"_D', { noremap = true, silent = true })
map({ "n", "v" }, "x", '"_x', { noremap = true, silent = true })

map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- buffers
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>bD", "<cmd>bwipeout<cr>", { desc = "Delete all buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Clear search with <esc >
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
map({ "i", "x", "n", "s" }, "<C-S>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- select all
map({ "i", "x", "n", "s" }, "<C-a>", "<ESC>G<S-v>ggy<esc>", { desc = "Select all" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Quickfix
map("n", "<leader>sl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>sq", "<cmd>copen<cr>", { desc = "Quickfix List" })

if not Util.has("trouble.nvim") then
    map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
    map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
end

-- toggle options
map("n", "<leader>us", function() Util.toggle("spell") end,
    {desc = "Toggle Spelling"})
map("n", "<leader>uw", function() Util.toggle("wrap") end,
    {desc = "Toggle Word Wrap"})
map("n", "<leader>ud", Util.toggle_diagnostics, {desc = "Toggle Diagnostics"})

-- quit
map("n", "<leader>q", "<cmd>qa<cr>", {desc = "Quit all"})

-- windows
map("n", "<leader>ww", "<C-W>p", {desc = "Other window", remap = true})
map("n", "<leader>wd", "<C-W>c", {desc = "Delete window", remap = true})
map("n", "<leader>w-", "<C-W>s", {desc = "Split window below", remap = true})
map("n", "<leader>w|", "<C-W>v", {desc = "Split window right", remap = true})
map("n", "<leader>-", "<C-W>s", {desc = "Split window below", remap = true})
map("n", "<leader>|", "<C-W>v", {desc = "Split window right", remap = true})

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", {desc = "Last Tab"})
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", {desc = "First Tab"})
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", {desc = "New Tab"})
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", {desc = "Next Tab"})
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", {desc = "Close Tab"})
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", {desc = "Previous Tab"})
