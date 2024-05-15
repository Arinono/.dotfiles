local lua = {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      diagnostics = { disable = { "missing-fields" } },
      telemetry = { enable = false },
    },
  },
}

local htmx = {}

local volar = {
  filetypes = { "vue" },
}

local ts = {
  filetypes = { "typescript", "javascript", "vue" },
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = "/Users/arinono/.local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin",
        languages = { "vue" },
      },
    },
  },
}

local ra = {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        features = "all",
      },
    },
  },
}

local M = {}

M.servers = {
  lua_ls = lua,
  htmx = htmx,
  tsserver = ts,
  volar = volar,
  rust_analyzer = ra,
}

return M
