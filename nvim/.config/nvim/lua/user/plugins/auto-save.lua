local import_plugin = require("user.util").import_plugin

local auto_save = import_plugin("autosave")

auto_save.setup({ execution_message = "",
    events = { "InsertLeave", "TextChanged" },
    conditions = {
        exists = true,
        filename_is_not = { "plugins.lua" },
        modifiable = true
    },
})
