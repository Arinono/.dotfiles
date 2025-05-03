local keys = {
  {
    "<leader>f",
    function()
      require("conform").format({ async = true, lsp_fallback = true })
    end,
    mode = "",
    desc = "[F]ormat buffer",
  },
}

local disabled = {
  c = true,
  cpp = true,
  js = true,
  ts = true,
  vue = true,
  nix = false,
}

local formatters = {
  lua = { "stylua" },
  js = { "prettier" },
  ts = { "prettier" },
  vue = { "prettier" },
  nix = { "alejandra" },
}

return {
  "stevearc/conform.nvim",
  lazy = false,
  keys = keys,
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      return {
        timeout_ms = 500,
        lsp_fallback = not disabled[vim.bo[bufnr].filetype],
      }
    end,
    formatters_by_ft = formatters,
  },
}
