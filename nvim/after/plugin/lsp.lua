local map = require("arinono.keymap")
local nnoremap = map.nnoremap

require('neoconf').setup({
  import = {
    vscode = false,
  }
})

local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.setup_servers({
  'tsserver',
  'eslint',
  'rust-analyzer',
})

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()

local cmp = require('cmp')
local cmp_select = { behaviour = cmp.SelectBehavior.Select }
local cmp_mapping = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-e>'] = cmp.mapping.close(),
})

cmp_mapping['<CR>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mapping
})

local config = require('lspconfig')

config.lua_ls.setup({
  settings = {
    Lua = {
      telemetry = { enable = false },
    }
  }
})

config.volar.setup({
  filetypes = {'vue'},
  init_options = {
    typescript = {
      tsdk = '/Users/arinono/Library/pnpm/global/5/node_modules/typescript/lib'
    }
  }
})

lsp.on_attach(function(_, buff)
  local opts = { buffer = buff, remap = false }

  nnoremap('<leader>vws', vim.lsp.buf.workspace_symbol, opts)
  nnoremap('<leader>vca', vim.lsp.buf.code_action, opts)
  nnoremap('<leader>qf', function()
    vim.lsp.buf.code_action({
      apply = true,
    })
  end, opts)
  nnoremap('<leader>rn', vim.lsp.buf.rename, opts)
  nnoremap('<C-h>', vim.lsp.buf.signature_help, opts)
  nnoremap('K', vim.lsp.buf.hover, opts)
  nnoremap('gd', vim.lsp.buf.definition, opts)
  nnoremap('gD', vim.lsp.buf.declaration, opts)
  nnoremap('gi', vim.lsp.buf.implementation, opts)
  nnoremap('gr', vim.lsp.buf.references, opts)
  nnoremap('go', vim.lsp.buf.type_definition, opts)
end)

lsp.setup()

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
    source = "always",
  },
})

nnoremap('<leader>do', function()
  vim.diagnostic.open_float(vim.api.nvim_get_current_buf(), { scope = "line" })
end)
