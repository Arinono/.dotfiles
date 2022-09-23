-- Theme style

-- Theme
vim.g.material_style = 'palenight'
vim.g.guifont=Dank_Mono

require('material').setup({
  disable = {
    colored_cursor = true,
  },
  italics = {
    comments = true,
    strings = true,
    keywords = true,
    functions = false,
    variables = false
  },
  high_visibility = {
    palenight = true,
  },
  custom_highlights = {
    LineNr = { fg = '#A5ABCC', bg = '#33384d' },
    ColorColumn = { bg = '#33384d' },
  },
})

local spotify = require('nvim-spotify').status
spotify:start()

-- Status line
require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'material',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,                                                                            },
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
})

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

-- Apply the colorscheme
vim.cmd 'colorscheme material'
