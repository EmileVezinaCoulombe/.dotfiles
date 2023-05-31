return {
  {
    "echasnovski/mini.indentscope",
    opts = function(_, opts)
      opts.draw = { delay = 0, animation = require("mini.indentscope").gen_animation.none() }
    end,
  },
}
