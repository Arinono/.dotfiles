local opts = {
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20,
    },
    presets = {
      operators = false,
      motions = false,
      text_objects = false,
      windows = true,
      nav = false,
      z = true,
      g = true,
    },
    icons = {
      breadcrumb = "»", 
      separator = "➜", 
      group = "+", 
    },
    popup_mappings = {
      scroll_down = '<c-d>', 
      scroll_up = '<c-u>', 
    },
    window = {
      border = "none", 
      position = "bottom", 
      margin = { 1, 0, 1, 0 }, 
      padding = { 2, 2, 2, 2 }, 
      winblend = 0
    },
    layout = {
      height = { min = 4, max = 50 }, -- min and max height of the columns
      width = { min = 20, max = 50 }, -- min and max width of the columns
      spacing = 5, -- spacing between columns
      align = "left", -- align columns left, center or right
    },
    show_help = true,
    show_keys = true,
    disable = {
      filetypes = {
        'TelescopePrompt',
      },
    },
  }
}

local mappings = {}

local wk = require('which-key')

wk.register(mappings, opts);
