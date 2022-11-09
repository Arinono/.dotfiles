-- Theme style

local spotify = require('nvim-spotify').status
spotify:start()

function lualine(theme)
  -- Status line
    return {
      icons_enabled = true,
      theme = theme,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {},
      always_divide_middle = true,
      globalstatus = false,
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {
          {
            'filename',
            path = 3
          }
        },
        lualine_x = {},
        lualine_y = { spotify.listen },
        lualine_z = { 'filetype' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      extensions = {}
    }
end

function material()
  vim.g.material_style = 'palenight'

  require('material').setup({
    disable = {
      colored_cursor = true,
    },
    styles = {
      comments = { italic = true },
      strings = { italic = true },
      keywords = { italic = true },
      functions = { italic = false },
      variables = { italic = false },
    },
    high_visibility = {
      palenight = true,
    },
    custom_highlights = {
      LineNr = { fg = '#A5ABCC', bg = '#33384d' },
      ColorColumn = { bg = '#33384d' },
    },
  })

  -- Status line
  require('lualine').setup(lualine('material'))
end

function tokyonight(variant)
  require('tokyonight').setup({
    style = variant,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      functions = { italic = false },
      variables = { italic = false },
      sidebars = 'dark',
    },
  })

  -- Status line
  require('lualine').setup(lualine('tokyonight'))
end

-- Icons
require('nvim-web-devicons').setup({
  -- your personnal icons can go here (to override)
  -- you can specify color or cterm_color instead of specifying both of them
  -- DevIcon will be appended to `name`
  override = {
    zsh = {
      icon = "",
      color = "#428850",
      cterm_color = "65",
      name = "Zsh"
    }
  };
  -- globally enable default icons (default to false)
  -- will get overriden by `get_icons` option
  default = true;
})

vim.g.guifont=Dank_Mono

tokyonight('storm')
-- material()

-- Apply the colorscheme
vim.cmd 'colorscheme tokyonight-storm'
-- vim.cmd 'colorscheme material'
