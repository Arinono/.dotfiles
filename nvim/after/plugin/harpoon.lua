require('harpoon').setup({
  tabline = true,
  menu = {
    width = math.floor(vim.api.nvim_win_get_width(0) * 0.3),
  }
})
