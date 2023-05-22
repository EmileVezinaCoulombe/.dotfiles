-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

if vim.fn.has("win32") then
  map("n", "<C-z>", "<Nop>", { noremap = true, silent = true })
  map("i", "<C-z>", "<Nop>", { noremap = true, silent = true })
  map("v", "<C-z>", "<Nop>", { noremap = true, silent = true })
  map("s", "<C-z>", "<Nop>", { noremap = true, silent = true })
  map("x", "<C-z>", "<Nop>", { noremap = true, silent = true })
  map("c", "<C-z>", "<Nop>", { noremap = true, silent = true })
  map("o", "<C-z>", "<Nop>", { noremap = true, silent = true })
end
