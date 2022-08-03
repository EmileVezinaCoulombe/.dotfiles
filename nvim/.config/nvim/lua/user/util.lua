local log = require("user.libraries.log")

utils = {}

function utils.import_plugin(plugin)
    local status_ok, plugin_imported = pcall(require, plugin)
    if not status_ok then
        log.error("Importation failed for plugin " .. plugin)
        return
    end
    return plugin_imported
end

return utils
