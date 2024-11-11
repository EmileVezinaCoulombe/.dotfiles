local M = {}

local start = vim.health.start or vim.health.report_start
local ok = vim.health.ok or vim.health.report_ok
local warn = vim.health.warn or vim.health.report_warn
local error = vim.health.error or vim.health.report_error

local function validate_cmd_are_executable(cmds)
    for _, cmd in ipairs(cmds) do
        local name = type(cmd) == "string" and cmd or vim.inspect(cmd)
        local commands = type(cmd) == "string" and { cmd } or cmd
        ---@cast commands string[]
        local found = false

        for _, c in ipairs(commands) do
            if vim.fn.executable(c) == 1 then
                name = c
                found = true
            end
        end

        if found then
            ok(("`%s` is installed"):format(name))
        else
            warn(("`%s` is not installed"):format(name))
        end
    end
end


local function validate_nvim_version(version)
    local nvim_version = version
    if vim.fn.has("nvim-" .. nvim_version) ~= 1 then
        ok("Using Neovim >= " .. nvim_version)
    else
        error("Neovim >= " .. nvim_version .. " is required")
    end
end


function M.check()
    start("Raven")

    validate_nvim_version("0.9.2")

    validate_cmd_are_executable({ "git", "rg", { "fd", "fdfind" }, "lazygit" })
end

return M
