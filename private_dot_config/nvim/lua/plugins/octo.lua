return {
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "folke/which-key.nvim",
        opts = {
          defaults = {
            ["<leader>go"] = { name = "+octo" },
          },
        },
      },
    },
    keys = {
      { "<leader>sp", "<cmd>Octo pr list<cr>", desc = "Pr git" },
      { "<leader>si", "<cmd>Octo issue list<cr>", desc = "Issues git" },
      { "<leader>gor", "<cmd>Octo review start<cr>", desc = "Review start pr" },
      { "<leader>goR", "<cmd>Octo review start<cr>", desc = "Review resume pr" },
      { "<leader>goc", "<cmd>Octo review commit<cr>", desc = "Review commit pr" },
      { "<leader>goC", "<cmd>Octo review comments<cr>", desc = "Review comments pr" },
      { "<leader>gos", "<cmd>Octo review submit<cr>", desc = "Review submit pr" },
    },
    opts = {},
  },
}
