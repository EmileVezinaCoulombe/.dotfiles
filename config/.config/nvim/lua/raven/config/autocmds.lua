-- Autocmds are automatically loaded on the VeryLazy event
local function augroup(name)
    return vim.api.nvim_create_augroup("raven_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

