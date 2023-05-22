return {
  {
    "nvim-telescope/telescope.nvim",
    config = function(plugin, opts)
      local new_maker = function(filepath, bufnr, opts)
        opts = opts or {}

        filepath = vim.fn.expand(filepath)
        vim.loop.fs_stat(filepath, function(_, stat)
          if not stat then
            return
          end
          if stat.size > 100000 then
            return
          else
            local previewers = require("telescope.previewers")
            previewers.buffer_previewer_maker(filepath, bufnr, opts)
          end
        end)
      end

      opts.defaults.buffer_previewer_maker = new_maker
      opts.pickers = {
        colorscheme = {
          enable_preview = true,
        },
      }
      require("telescope").setup(opts)
    end,
  },
}
