local Util = require("lazy.core.util")

local M = {}

M.root_patterns = { ".git", "lua", "package.json" }
M.is_unix = vim.fn.has("macunix") == 1 or vim.fn.has("unix") == 1

function M.map(mode, lhs, rhs, opts)
    local keys = require("lazy.core.handler").handlers.keys
    ---@cast keys LazyKeysHandler
    -- do not create the keymap if a lazy keys handler exists
    if not keys.active[keys.parse({ lhs, mode = mode }).id] then
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

---@param plugin string
function M.has(plugin)
    return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

---@param name string
function M.opts(name)
    local plugin = require("lazy.core.config").plugins[name]
    if not plugin then
        return {}
    end
    local Plugin = require("lazy.core.plugin")
    return Plugin.values(plugin, "opts", false)
end

---@return string
function M.get_root()
    local cwd = vim.loop.cwd()
    ---@cast cwd string
    return cwd
end

---@return string
function M.reduce_path_to_root_patern(path)
    local dir = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    -- local root_path = vim.fs.find(M.root_patterns, { path = dir, upward = true })[1]
    -- local root_dir = root_path and vim.fs.dirname(root_path) or vim.loop.cwd()

    local root_dir = dir
    ---@cast root_dir string
    return root_dir
end

---@param option string
function M.toggle(option)
    vim.opt_local[option] = not vim.opt_local[option]:get()
end

local enabled = true
function M.toggle_diagnostics()
    enabled = not enabled
    if enabled then
        vim.diagnostic.enable()
        Util.info("Enabled diagnostics", { title = "Diagnostics" })
    else
        vim.diagnostic.disable()
        Util.warn("Disabled diagnostics", { title = "Diagnostics" })
    end
end

---Get the venv executable path
---@return string?
function M.venv_python_path()
    local venv_path = vim.fn.glob(require("raven.utils").get_root() .. "/venv/")

    if venv_path == "" then
        Util.warn("Missing venv path", { title = "Missing install" })
    elseif M.is_unix then
        return venv_path .. "bin/python"
    else
        return venv_path .. "Scripts\\python.exe"
    end
    return nil
end

return M
