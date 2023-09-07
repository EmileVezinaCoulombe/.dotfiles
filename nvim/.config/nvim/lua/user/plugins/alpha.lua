local headers = require("user.static.headers").ascii_group
local import_plugin = require("user.util").import_plugin

local alpha = import_plugin("alpha")
local dashboard = import_plugin("alpha.themes.dashboard")

math.randomseed(os.time())
dashboard.section.header.val = headers[math.random(1, #headers)]

dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
