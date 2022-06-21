local home = os.getenv('HOME')

local status_ok, dashboard = pcall(require, "dashboard")
if not status_ok then
    return
end

-- https://www.patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=NEOVIM
dashboard.preview_command = 'cat | lolcat -F 0.3'
dashboard.preview_file_path = home .. '/.config/nvim/static/neovim.cat'
dashboard.preview_file_height = 11
dashboard.preview_file_width = 42
dashboard.custom_center = {
    {
        icon = " ",
        desc = " Find project                        ",
        shortcut = "SPC u p",
        action = "lua require('telescope').extensions.projects.projects()"
    },
    {
        icon = " ",
        desc = " Find file                           ",
        shortcut = "SPC u f",
        action = "Telescope find_files"
    },
    {
        icon = " ",
        desc = " New file                            ",
        shortcut = "SPC u e",
        action = "ene <BAR> startinsert"
    },
    {
        icon = " ",
        desc = " Recent files                        ",
        shortcut = "SPC u r",
        action = "Telescope oldfiles"
    },
    {
        icon = " ",
        desc = " Find text                           ",
        shortcut = "SPC u t",
        action = "Telescope live_grep"
    },
    {
        icon = " ",
        desc = " Config                              ",
        shortcut = "SPC u c",
        action = "e ~/.config/nvim/init.lua"
    },
    {
        icon = " ",
        desc = " Quit                                ",
        shortcut = "SPC u q",
        action = "qa"
    },
}
