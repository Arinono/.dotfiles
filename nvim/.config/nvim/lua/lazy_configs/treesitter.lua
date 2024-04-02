local M = {}

M.installed = {
  "vim",
  "c",
  "bash",
  "lua",
  "rust",
  "toml",
  "javascript",
  "typescript",
}

M.context = {
  enable = true,
  throttle = true,
  max_lines = 0,
  patterns = {
    default = {
      "class",
      "function",
      "method",
      "for",
      "if",
    },

    rust = {
      "impl_item",
    },

    typescript = {
      "class_declaration",
      "abstract_class_declaration",
      "else_clause",
    },
  },
}

return M
