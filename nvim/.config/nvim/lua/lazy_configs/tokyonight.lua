local M = {}

function M.init()
  require('tokyonight').setup {
    style = 'storm',
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      functions = { italic = false },
      variables = { italic = false },
      sidebars = 'dark',
    },
    on_colors = function(colors)
      colors.border = '#9c9c9c'
    end,
  }
end

return M
