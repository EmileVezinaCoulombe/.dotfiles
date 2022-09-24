local import_plugin = require("user.util").import_plugin

local neorg = import_plugin("neorg")

neorg.setup({
    load = {
        ["core.defaults"] = {},
        ["core.ui"] = {
            config = {
            }
        },
        ["core.export"] = {
            config = {
            }
        },
        ["core.export.markdown"] = {
            config = {
            }
        },
        ["core.norg.completion"] = {
            config = {
                engine = "nvim-cmp"
            }
        },
        ["core.integrations.nvim-cmp"] = {
            config = {
            }
        },
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    gcd = "~/Nextcloud/USER-Emile/gcd",
                },
                autochdir = true, -- Automatically change the directory to the current workspace's root every time
                index = "index.norg", -- The name of the main (root) .norg file
                default_workspace = "gcd",
                open_last_workspace = true,
            }
        },
        ["core.presenter"] = {
            config = {
                zen_mode = "zen-mode"
            }
        },
        ["core.norg.concealer"] = {
            config = {
            }
        },
        ["core.norg.qol.toc"] = {
            config = {
            }
        },
        ["core.norg.journal"] = {
            config = {
            }
        },
        ["core.gtd.base"] = {
            config = {
                workspace = "gcd"
            }
        },
        ["core.gtd.ui"] = {
            config = {
            }
        },
        ["core.gtd.helpers"] = {
            config = {
            }
        },
        ["core.gtd.queries"] = {
            config = {
            }
        },
    }
})
