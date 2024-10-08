local function highlight_word(event)
  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if client and client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = event.buf,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = event.buf,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local function add_capability(mode, cap)
  capabilities = vim.tbl_deep_extend(mode, capabilities, cap)
end

local function setup_diagnostics()
  vim.diagnostic.config({
    virtual_text = {
      source = "if_many",
    },
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = {
      reverse = true,
    },
    float = {
      source = true,
    },
  })
end

local _map = function(event)
  return function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
  end
end

local function register_keymaps(event)
  local map = _map(event)

  map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

  map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

  map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

  map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

  map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

  map(
    "<leader>ws",
    require("telescope.builtin").lsp_dynamic_workspace_symbols,
    "[W]orkspace [S]ymbols"
  )

  map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

  map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  map("K", vim.lsp.buf.hover, "Hover Documentation")

  map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

  map("<leader>sh", vim.lsp.buf.signature_help, "[S]ignature [H]elp")

  map("<leader>qf", function()
    vim.lsp.buf.code_action({
      apply = true,
    })
  end, "[Q]uick [F]ix")
end

local lua = {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      diagnostics = {
        disable = { "missing-fields", "lowercase-global" },
        globals = { "vim", "obslua" },
      },
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

local servers = {
  lua_ls = lua,
  htmx = htmx,
  ts_ls = ts,
  volar = volar,
  rust_analyzer = ra,
}

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    { "j-hui/fidget.nvim", opts = {} },

    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
      callback = function(event)
        register_keymaps(event)

        -- lazy_configs.lsp.autocmds.highlight_word(event)
      end,
    })

    add_capability("force", require("cmp_nvim_lsp").default_capabilities())

    require("mason").setup()

    setup_diagnostics()

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      "stylua",
    })

    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for tsserver)
          server.capabilities =
            vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })
  end,
}
