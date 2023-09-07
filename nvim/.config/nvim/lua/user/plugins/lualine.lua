local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
    return
end

local hide_in_width = function()
    return vim.fn.winwidth(0) > 80
end

local breadcrump_sep = " ⟩ "
local left_sep = ""
local right_sep = ""

local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn" },
    symbols = { error = "✖ ", warn = " " },
    colored = false,
    update_in_insert = false,
    always_visible = true,
}

local diff = {
    "diff",
    colored = false,
    symbols = { added = " ", modified = "李", removed = " " }, -- changes diff symbols
    cond = hide_in_width,
}

local filetype = {
    "filetype",
    icons_enabled = true,
}

local branch = {
    "branch",
    icons_enabled = true,
    icon = "",
}

local location = {
    "location",
    separator = { right = right_sep },
    left_padding = 3,
}

local mode = {
    'mode',
    separator = { left = left_sep },
    right_padding = 3,
}
local progress = {
    "progress",
}

local spaces = function()
    return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

lualine.setup {
    options = {
        globalstatus = true,
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = '|', right = '|' },
        section_separators = { left = right_sep, right = left_sep },
        disabled_filetypes = { "alpha", "dashboard" },
        always_divide_middle = true,
    },
    sections = {
        lualine_a = { mode },
        lualine_b = { diff, branch },
        lualine_c = {
            {
                -- https://github.com/ikalnytskyi/dotfiles/blob/2bf3482b7b5d4d87b331739e66340953d8c9966a/nvim/.config/nvim/init.lua#L588-L598
                "filename",
                path = 1,
                separator = vim.trim(breadcrump_sep),
                fmt = function(str)
                    local path_separator = package.config:sub(1, 1)
                    return str:gsub(path_separator, breadcrump_sep)
                end
            },
            { "aerial", sep = breadcrump_sep },
        },
        lualine_x = {},
        lualine_y = { filetype, diagnostics, progress },
        lualine_z = { location },
    },
}
