return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    init = function()
      require("tokyonight").setup({
        style = "storm",
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = { italic = false },
          variables = { italic = false },
          sidebars = "dark",
        },
        on_colors = function(colors)
          colors.border = "#9c9c9c"
        end,
      })
      vim.cmd.colorscheme("tokyonight-storm")
    end,
  },
  { "catppuccin/nvim", name = "catppuccin", priority = 500 },
  { "ellisonleao/gruvbox.nvim", name = "gruvbox", priority = 500 },
  {
    "brenoprata10/nvim-highlight-colors",
    opts = {
      enable_tailwind = true,
    },
  },
}
