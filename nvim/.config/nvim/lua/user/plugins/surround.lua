local status_ok, surround = pcall(require, 'nvim-surround')
if not status_ok then
    return
end

surround.setup({
    keymaps = { -- vim-surround style keymaps
        insert = "ys",
        insert_line = "yss",
        visual = "S",
        delete = "ds",
        change = "cs",
    },
    highlight = { -- Highlight before inserting/changing surrounds
        duration = 0,
    }
})
