local import_plugin = require("user.util").import_plugin
require "user.palettes"

-- tokyonight
vim.g.tokyonight_style = "night" -- storm, night, day

-- kanagawa
local kanagawa = import_plugin("kanagawa")
kanagawa.setup({
})

local default_colors = import_plugin("kanagawa.colors")

default_colors.setup()

local overrides = {
    FloatBorder = { fg = "#1F1F28" },
}

kanagawa.setup({ overrides = overrides })

-- Color Scheme selection

vim.cmd('colorscheme kanagawa')
-- local colorscheme = "catppuccin"
-- local colorscheme = "tokyonight"
local colorscheme = "kanagawa"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
    vim.notify("colorscheme " .. colorscheme .. " not found!")
    return
end
