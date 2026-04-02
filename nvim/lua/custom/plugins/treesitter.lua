local parsers = {
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
  branch = "main",
  lazy = false,
  opts = {
    ensure_installed = parsers,
  },
  config = function(_, opts)
    -- require("nvim-treesitter").install(parsers)
    -- vim.treesitter.language.register("markdown", { "mdx" })

    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        local buf, filetype = args.buf, args.match

        local language = vim.treesitter.language.get_lang(filetype)
        if not language then
          return
        end


        -- check if parser exists and load it
        if not vim.treesitter.language.add(language) then
          return
        end

        -- enables syntax highlighting and other treesitter features
        vim.treesitter.start(buf, language)

        -- enables treesitter based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
