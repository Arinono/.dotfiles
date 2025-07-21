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
  -- vim.keymap.set("n", "K", vim.lsp.buf.hover)
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
  'neovim/nvim-lspconfig',
  dependencies = {
    "nvimdev/lspsaga.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",

    { "j-hui/fidget.nvim",  opts = {} },

    { "folke/lazydev.nvim", opts = {} },
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

    local vue_language_server_path = vim.fn.stdpath('data') ..
        "/mason/packages/vue-language-server/node_modules/@vue/language-server"
    local vue_plugin = {
      name = '@vue/typescript-plugin',
      location = vue_language_server_path,
      languages = { 'vue' },
      configNamespace = 'typescript',
    }
    local servers = {
      vue_ls = {
        on_init = function(client)
          client.handlers['tsserver/request'] = function(_, result, context)
            local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
            if #clients == 0 then
              vim.notify('Could not find `vtsls` lsp client, `vue_ls` would not work without it.', vim.log.levels.ERROR)
              return
            end
            local ts_client = clients[1]

            local param = unpack(result)
            local id, command, payload = unpack(param)
            ts_client:exec_cmd({
              title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
              command = 'typescript.tsserverRequest',
              arguments = {
                command,
                payload,
              },
            }, { bufnr = context.bufnr }, function(_, r)
              local response_data = { { id, r.body } }
              ---@diagnostic disable-next-line: param-type-mismatch
              client:notify('tsserver/response', response_data)
            end)
          end
        end,
      },
      vtsls = {
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                vue_plugin,
              },
            },
          },
        },
        filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
      },
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

      nil_ls = {
        manual_install = true,
      },
      alejandra = {
        manual_install = true,
      }
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
      "eslint",
    }

    vim.list_extend(ensure_installed, servers_to_install)

    for server_name, server in pairs(servers) do
      vim.lsp.config(server_name, server)
      vim.lsp.enable(server_name)
    end

    require("mason-lspconfig").setup({
      ensure_installed = ensure_installed
    })
  end,
}
