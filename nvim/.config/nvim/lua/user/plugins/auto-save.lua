local import_plugin = require("user.util").import_plugin

local auto_save = import_plugin("auto-save")

auto_save.setup({
    execution_message = {
        message = function() -- message to print on save
            return ("")
        end,
        dim = 0, -- dim the color of `message`
        cleaning_interval = 0, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
    },
    -- trigger_events = { "InsertLeave", "TextChanged" }, -- vim events that trigger auto-save. See :h events
    -- function that determines whether to save the current buffer or not
    -- return true: if buffer is ok to be saved
    -- return false: if it's not ok to be saved
    -- condition = function(buf)
    --     local fn = vim.fn
    --     local utils = require("auto-save.utils.data")
    --
    --     if fn.getbufvar(buf, "&modifiable") == 1 or
    --         utils.not_in(fn.getbufvar(buf, "&filetype"), {}) or
    --         utils.not_in(vim.api.nvim_buf_get_name(0), {"plugins.lua"}) then
    --         return true -- met condition(s), can save
    --     end
    --     return false -- can't save
    -- end,
})
