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

local function register_keymaps()
  local builtin = require("telescope.builtin")

  vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = 0 })
  vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = 0 })
  vim.keymap.set("n", "gI", builtin.lsp_implementations, { buffer = 0 })
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })

  vim.keymap.set("n", "<leader>D", builtin.lsp_type_definitions, { buffer = 0 })
  vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols, { buffer = 0 })
  vim.keymap.set("n", "<leader>ws", builtin.lsp_dynamic_workspace_symbols, { buffer = 0 })
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = 0 })
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })
  vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, { buffer = 0 })
  vim.keymap.set("n", "<leader>qf", function()
    vim.lsp.buf.code_action({
      apply = true,
    })
  end, { buffer = 0 })

  vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "[L]SP [R]estart" })
end

-- Function to highlight current word
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

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    { "j-hui/fidget.nvim", opts = {} },

    { "folke/neodev.nvim", opts = {} },
  },
  otps = {
    inlay_hints = { enabled = false },
  },
  config = function()
    if vim.g.obsidian then
      return
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
      callback = function(event)
        register_keymaps()
        -- highlight_word(event)
      end,
    })

    add_capability("force", require("cmp_nvim_lsp").default_capabilities())

    local lspconfig = require("lspconfig")

    local servers = {
      volar = {
        -- Volar will handle Vue files only
        filetypes = { "vue" },
        root_dir = lspconfig.util.root_pattern(
          "package.json",
          "vue.config.js",
          "nuxt.config.js",
          ".git"
        ),
        init_options = {
          typescript = {
            tsdk = vim.fn.expand(
              "$HOME/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/lib"
            ),
          },
          vue = {
            hybridMode = false, -- Disable hybrid mode for full Volar TS support
          },
        },
      },
      -- TypeScript configuration using vtsls (modern TS server)
      vtsls = {
        single_file_support = true,
        root_dir = lspconfig.util.root_pattern(
          "package.json",
          "tsconfig.json",
          "jsconfig.json",
          ".git"
        ),
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
      },
      htmx = {},
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              features = "all",
            },
          },
        },
      },
      typos_lsp = {
        init_options = {
          diagnosticSeverity = "Hint",
        },
      },
      lua_ls = {
        settings = {
          Lua = {
            format = {
              enable = true,
            },
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
      },
    }

    local servers_to_install = vim.tbl_filter(function(key)
      local t = servers[key]
      if type(t) == "table" then
        return not t.manual_install
      else
        return t
      end
    end, vim.tbl_keys(servers))

    require("mason").setup()

    setup_diagnostics()

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = {
      "stylua",
      "lua_ls",
      "vue-language-server",
      "vtsls",
      "eslint-lsp",
      "prettier",
    }
    vim.list_extend(ensure_installed, servers_to_install)

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

          lspconfig[server_name].setup({
            capabilities = server.capabilities,
            on_attach = server.on_attach,
            single_file_support = server.single_file_support,
            root_dir = server.root_dir,
            settings = server.settings,
            filetypes = server.filetypes,
            cmd = server.cmd,
            init_options = server.init_options,
          })
        end,
      },
    })
  end,
}
