local function getMainBrach()
  local root_dir = require("lazyvim.util").get_root()
  if root_dir:find("Nomis") then
    return "Developper"
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
