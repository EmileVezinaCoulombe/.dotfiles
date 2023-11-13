local function getMainBrach()
    local root_dir = require("raven.utils").get_root()
    -- Use % for special characters ^$()%.[]*+-?) ex: https://www.lua.org/manual/5.1/manual.html#pdf-string.format
    if string.find(root_dir, "projet2023%-eq05") then
        return "develop"
    end
    return "main"
end
return {
    {
        "sindrets/diffview.nvim",
        opts = {
            default_args = {
                DiffviewOpen = { "--imply-local" },
                DiffviewFileHistory = { "--imply-local" },
            },
        },
        keys = {
            {
                "<leader>gb",
                "<cmd>DiffviewOpen origin/" .. getMainBrach() .. "...HEAD --imply-local<cr>",
                desc = "DiffView Branche changes",
            },
            {
                "<leader>gB",
                "<cmd>:DiffviewFileHistory --range=origin/" .. getMainBrach() .. "...HEAD --right-only --no-merges<cr>",
                desc = "DiffView Branche commits",
            },
            { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView Current changes" },
            { "<leader>g%", "<cmd>DiffviewFileHistory %<cr>", desc = "DiffView File History" },
        },
    },
}
