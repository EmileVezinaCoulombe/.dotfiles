-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- local util = require("lazyvim.util")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
-- local usercmd = vim.api.nvim_buf_create_user_command

augroup("clear_group", { clear = true })

autocmd("Filetype", {
  pattern = "neo-tree",
  callback = function()
    vim.cmd("UfoDetach")
  end,
  group = "clear_group",
  desc = "Disable Ufo for neo-tree",
})
