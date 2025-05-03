local installed = {
  "vim",
  "c",
  "bash",
  "lua",
  "rust",
  "toml",
  "javascript",
  "typescript",
  "markdown",
}

local context = {
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

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = installed,
    -- Autoinstall languages that are not installed
    auto_install = true,
    sync = false,
    highlight = {
      enable = true,
      disable = { "help" },
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-context",
    opts = context,
    "nvim-treesitter/playground",
  },
  config = function(_, opts)
    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup(opts)

    vim.treesitter.language.register("markdown", { "mdx" })
  end,
}
