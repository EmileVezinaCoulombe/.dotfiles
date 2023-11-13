return {
  {
    "ThePrimeagen/harpoon",
    dependencies = {
      {
        "folke/which-key.nvim",
        opts = {
          defaults = {
            ["<leader>j"] = { name = "+Harpoon" },
          },
        },
      },
    },

    keys = {
      {
        "[j",
        function()
          require("harpoon.ui").nav_prev()
        end,
        desc = "Previous Harpoon",
      },
      {
        "]j",
        function()
          require("harpoon.ui").nav_next()
        end,
        desc = "Next Harpoon",
      },
      {
        "<leader>ja",
        function()
          require("harpoon.mark").add_file()
        end,
        desc = "Add File",
      },
      {
        "<leader>jm",
        function()
          require("harpoon.ui").toggle_quick_menu()
        end,
        desc = "File Menu",
      },
      {
        "<leader>jc",
        function()
          require("harpoon.cmd-ui").toggle_quick_menu()
        end,
        desc = "Command Menu",
      },
      {
        "<leader>1",
        function()
          require("harpoon.ui").nav_file(1)
        end,
        desc = "File 1",
      },
      {
        "<leader>2",
        function()
          require("harpoon.ui").nav_file(2)
        end,
        desc = "File 2",
      },
      {
        "<leader>3",
        function()
          require("harpoon.ui").nav_file(3)
        end,
        desc = "File 3",
      },
    },
    opts = {
      global_settings = {
        save_on_toggle = true,
        enter_on_sendcmd = true,
      },
    },
  },
}
