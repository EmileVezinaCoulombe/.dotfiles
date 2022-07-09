local status_ok, auto_save = pcall(require, "autosave")

if not status_ok then
    return
end

auto_save.setup({ execution_message = "",
    events = { "InsertLeave", "TextChanged" },
    conditions = {
        exists = true,
        filename_is_not = { "plugins.lua" },
        modifiable = true
    },
})
