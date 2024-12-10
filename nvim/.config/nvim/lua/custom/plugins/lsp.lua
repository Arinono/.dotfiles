-- local function highlight_word(event)
--   local client = vim.lsp.get_client_by_id(event.data.client_id)
--   if client and client.server_capabilities.documentHighlightProvider then
--     vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--       buffer = event.buf,
--       callback = vim.lsp.buf.document_highlight,
--     })
--
--     vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
--       buffer = event.buf,
--       callback = vim.lsp.buf.clear_references,
--     })
--   end
-- end

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

  map("gd", function()
    require("telescope.builtin").lsp_definitions({ show_pine = false })
  end, "[G]oto [D]efinition")

  map("gr", function()
    require("telescope.builtin").lsp_references({ show_line = false })
  end, "[G]oto [R]eferences")

  map("gI", function()
    require("telescope.builtin").lsp_implementations({ show_line = false })
  end, "[G]oto [I]mplementation")

  map("<leader>D", function()
    require("telescope.builtin").lsp_type_definitions({ show_line = false })
  end, "Type [D]efinition")

  map("<leader>ds", function()
    require("telescope.builtin").lsp_document_symbols({ show_line = false })
  end, "[D]ocument [S]ymbols")

  map("<leader>ws", function()
    require("telescope.builtin").lsp_dynamic_workspace_symbols({ show_line = false })
  end, "[W]orkspace [S]ymbols")

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
    if vim.g.obsidian then
      return
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
      callback = function(event)
        register_keymaps(event)

        -- lazy_configs.lsp.autocmds.highlight_word(event)
      end,
    })

    add_capability("force", require("cmp_nvim_lsp").default_capabilities())

    local lspconfig = require("lspconfig")

    local servers = {
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
      htmx = {},
      ts_ls = {
        filetypes = { "typescript", "javascript", "vue" },
        root_dir = lspconfig.util.root_pattern(".git"),
        init_options = {
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = "/Users/arinono/.local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin",
              languages = { "vue" },
            },
          },
        },
      },
      volar = {
        filetypes = { "vue" },
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
            -- on_attach = on_attach,
            single_file_support = server.single_file_support,
            root_dir = server.root_dir,
            settings = server.settings,
            filetypes = server.filetypes,
          })
        end,
      },
    })
  end,
}
