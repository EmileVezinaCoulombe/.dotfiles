local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
    return
end

local hide_in_width = function()
    return vim.fn.winwidth(0) > 80
end

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
    separator = { right = "" },
    left_padding = 3,
}

local mode = {
    'mode',
    separator = { left = '' },
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
        section_separators = { left = '', right = '' },
        disabled_filetypes = { "alpha", "dashboard" },
        always_divide_middle = true,
    },
    sections = {
        lualine_a = { mode },
        lualine_b = { diff, branch },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { filetype, diagnostics, progress },
        lualine_z = { location },
    },
}
