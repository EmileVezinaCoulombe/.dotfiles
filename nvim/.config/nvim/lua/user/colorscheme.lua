require "user.palettes"

-- tokyonight
vim.g.tokyonight_style = "night" -- storm, night, day

-- kanagawa
local kanagawa_status_ok, kanagawa = pcall( require, "kanagawa")
if not kanagawa_status_ok then
    return
end

kanagawa.setup({})

-- local colorscheme = "catppuccin"
-- local colorscheme = "tokyonight"
local colorscheme = "kanagawa"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
