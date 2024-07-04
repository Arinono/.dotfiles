return {
  {
    "declancm/maximize.nvim",
    config = true,
    opts = {
      plugins = {
        aerial = { enable = false },
        dapui = { enable = false },
        tree = { enable = false },
      },
    },
    keys = {
      {
        "<leader>z",
        function()
          require("maximize").toggle()
        end,
        mode = "n",
        desc = "Toggle maximize",
      },
    },
  },
}
