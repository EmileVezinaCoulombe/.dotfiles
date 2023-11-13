---@type RavenConfig
local M = {}

---@class RavenConfig
local defaults = {
    -- colorscheme can be a string like `catppuccin` or a function that will load the colorscheme
    ---@type integer
    light_start_hour = 5,
    ---@type integer
    light_stop_hour = 19,
    ---@type string|fun()
    light_colorscheme = "github_light",
    ---@type string|fun()
    dark_colorscheme = "kanagawa",
    spec = {
        { import = "raven.plugins" },
        { import = "raven.plugins.coding" },
        { import = "raven.plugins.dap" },
        { import = "raven.plugins.editor" },
        { import = "raven.plugins.formatting" },
        { import = "raven.plugins.lang" },
        { import = "raven.plugins.linting.eslint" },
        { import = "raven.plugins.test" },
        { import = "raven.plugins.ui" },
        { import = "raven.plugins.util" },
    },
    checker = { enabled = false }, -- automatically check for plugin updates
    performance = {
        rtp = {
            -- disable some rtp plugins
            disabled_plugins = {
                "gzip", -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
    -- icons used by other plugins
    icons = {
        dap = {
            Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
            Breakpoint = " ",
            BreakpointCondition = " ",
            BreakpointRejected = { " ", "DiagnosticError" },
            LogPoint = ".>",
        },
        diagnostics = {
            Error = " ",
            Warn = " ",
            Hint = " ",
            Info = " ",
        },
        git = { added = " ", modified = " ", removed = " " },
        kinds = {
            Array = " ",
            Boolean = " ",
            Class = " ",
            Color = " ",
            Constant = " ",
            Constructor = " ",
            Copilot = " ",
            Enum = " ",
            EnumMember = " ",
            Event = " ",
            Field = " ",
            File = " ",
            Folder = " ",
            Function = " ",
            Interface = " ",
            Key = " ",
            Keyword = " ",
            Method = " ",
            Module = " ",
            Namespace = " ",
            Null = " ",
            Number = " ",
            Object = " ",
            Operator = " ",
            Package = " ",
            Property = " ",
            Reference = " ",
            Snippet = " ",
            String = " ",
            Struct = " ",
            Text = " ",
            TypeParameter = " ",
            Unit = " ",
            Value = " ",
            Variable = " ",
        },
    },
}

function M.setup()
    -- load options before lazy init
    M.load("options")
    require("lazy").setup({ spec = defaults.spec })
    M.load("autocmds")
    M.load("keymaps")
    M.load("options")
    M.load_colorscheme()
end

---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
    name = "raven.config." .. name
    local Util = require("lazy.core.util")
    local function _load(mod)
        Util.try(function()
            require(mod)
        end, {
            msg = "Failed loading " .. mod,
            on_error = function(msg)
                local info = require("lazy.core.cache").find(mod)
                if info == nil or (type(info) == "table" and #info == 0) then
                    return
                end
                Util.error(msg)
            end,
        })
    end
    _load(name)
end

function M.load_colorscheme()
    local timer = vim.loop.new_timer()
    require("lazy.core.util").try(function()
        local function set_colorscheme(force)
            local is_light_set = M.light_colorscheme == vim.g.colors_name
            local is_dark_set = M.dark_colorscheme == vim.g.colors_name
            if force or is_light_set or is_dark_set then
                local hr = tonumber(os.date("%H", os.time()))
                local background = "dark"
                local colorscheme = M.dark_colorscheme
                if hr > M.light_start_hour and hr < M.light_stop_hour then
                    background = "light"
                    colorscheme = M.light_colorscheme
                end
                vim.opt.background = background
                if type(colorscheme) == "function" then
                    colorscheme()
                else
                    vim.cmd.colorscheme(colorscheme)
                end
            end
        end
        set_colorscheme(true)
        if timer then
            local no_timout = 0
            local ten_seconds = 10000
            timer:start(no_timout, ten_seconds, vim.schedule_wrap(set_colorscheme))
        end
    end, {
        msg = "Could not load your colorscheme",
        on_error = function(msg)
            require("lazy.core.util").error(msg)
            vim.cmd.colorscheme("habamax")
            if timer then
                vim.loop.timer_stop(timer)
            end
        end,
    })
end

setmetatable(M, {
    __index = function(_, key)
        return defaults[key]
    end,
})

return M
