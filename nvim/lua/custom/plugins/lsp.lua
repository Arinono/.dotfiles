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

  vim.keymap.set("n", "gd", builtin.lsp_definitions)
  vim.keymap.set("n", "gr", builtin.lsp_references)
  vim.keymap.set("n", "gI", builtin.lsp_implementations)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
  vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<cr>")

  vim.keymap.set("n", "<leader>D", builtin.lsp_type_definitions)
  vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols)
  vim.keymap.set("n", "<leader>ws", builtin.lsp_dynamic_workspace_symbols)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
  vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help)
  vim.keymap.set("n", "<leader>qf", function()
    vim.lsp.buf.code_action({
      apply = true,
    })
  end)

  vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "[L]SP [R]estart" })
end

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "nvimdev/lspsaga.nvim",
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
    register_keymaps()
    require("lspsaga").setup({
      ui = {
        code_action = "",
      },
    })

    add_capability("force", require("cmp_nvim_lsp").default_capabilities())

    local lspconfig = require("lspconfig")

    local servers = {
      vue_ls = {
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
            hybridMode = true,
          },
        },
      },
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
      -- ts_ls = {
      --   filetypes = { "typescript", "javascript", "vue" },
      --   root_dir = lspconfig.util.root_pattern(".git"),
      --   -- cmd = { "/Users/arinono/workspace/typescript-go/built/local/tsgo", "lsp", "--stdio" },
      --   init_options = {
      --     plugins = {
      --       {
      --         name = "@vue/typescript-plugin",
      --         location = "/Users/arinono/.local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin",
      --         languages = { "vue" },
      --       },
      --     },
      --   },
      -- },
      -- htmx = {},
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

      golangci_lint_ls = {
        filetypes = { "go", "gomod" },
        cmd = { "golangci-lint-langserver" },
        init_options = {
          command = { "golangci-lint", "run", "--output.json.path=stdout", "--show-stats=false" },
        },
        root_markers = {
          ".golangci.yml",
          ".golangci.yaml",
          ".golangci.toml",
          ".golangci.json",
          "go.work",
          "go.mod",
          ".git",
        },
      },
      gopls = {
        manual_install = true,
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        cmd = { "gopls" },
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

    require("mason").setup({
      PATH = "prepend",
    })

    setup_diagnostics()

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = {
      "stylua",
      "eslint-lsp",
      "prettier",
      "ts_ls", -- for volar
    }
    vim.list_extend(ensure_installed, servers_to_install)

    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

    -- Installed via nix profile for now
    vim.lsp.enable("nil")
    vim.lsp.enable("alejandra")
    vim.lsp.enable("gopls")

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
