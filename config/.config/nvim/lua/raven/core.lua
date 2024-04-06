---@class RavenConfig
local M = {
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
        { import = "raven.plugins.formatting" },
        { import = "raven.plugins.lang" },
        { import = "raven.plugins.linting.eslint" },
        { import = "raven.plugins.test" },
    },
    checker = { enabled = false }, -- automatically check for plugin updates
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

    require("raven.config.options")

    require("lazy").setup({ spec = M.spec })
    M.load_colorscheme()

    require("raven.config.autocmds")
    require("raven.config.keymaps")

    -- TODO: 2 times ?
    require("raven.config.options")
end

function M.load_colorscheme()
    local function watch_colorscheme()
        local function update_colorscheme(background, colorscheme)
            vim.opt.background = background
            if type(colorscheme) == "function" then
                colorscheme()
            else
                vim.cmd.colorscheme(colorscheme)
            end
        end

        local hr = tonumber(os.date("%H", os.time()))
        local is_light_time = hr >= M.light_start_hour and hr < M.light_stop_hour


        if M.light_colorscheme ~= vim.g.colors_name and is_light_time then
            update_colorscheme("light", M.light_colorscheme)
        end

        if M.dark_colorscheme ~= vim.g.colors_name and not is_light_time then
            update_colorscheme("dark", M.dark_colorscheme)
        end
    end

    watch_colorscheme()
    vim.loop.new_timer():start(0, 10000, vim.schedule_wrap(watch_colorscheme))
end

return M
