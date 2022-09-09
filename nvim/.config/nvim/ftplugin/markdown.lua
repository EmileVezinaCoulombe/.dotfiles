local options = {
    wrap = true,
    textwidth=120,
    linebreak=true,
    colorcolumn = "0",
}
-- :help options

for k, v in pairs(options) do
    vim.opt[k] = v
end
