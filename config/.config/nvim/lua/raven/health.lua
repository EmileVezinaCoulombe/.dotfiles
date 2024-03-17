local M = {}

local start = vim.health.start or vim.health.report_start
local ok = vim.health.ok or vim.health.report_ok
local warn = vim.health.warn or vim.health.report_warn
local error = vim.health.error or vim.health.report_error

function M.check()
    start("Raven")

    local nvim_version = "0.9.2"
    if vim.fn.has("nvim-" .. nvim_version) ~= 1 then
        ok("Using Neovim >= " .. nvim_version)
    else
        error("Neovim >= " .. nvim_version .. " is required")
    end

    for _, cmd in ipairs({ "git", "rg", { "fd", "fdfind" }, "lazygit" }) do
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

return M
