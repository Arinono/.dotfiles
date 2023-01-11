local map = require("arinono.keymap")
local nnoremap = map.nnoremap

local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.ensure_installed({
  'tsserver',
  'eslint',
  'sumneko_lua',
  'rust_analyzer',
})

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

config.sumneko_lua.setup({
  settings = {
    Lua = {
      telemetry = { enable = false },
    }
  }
})

lsp.on_attach(function(_, buff)
  local opts = { buffer = buff, remap = false }

  nnoremap('<leader>vws', vim.lsp.buf.workspace_symbol, opts)
  nnoremap('<leader>vca', vim.lsp.buf.code_action, opts)
  nnoremap('<leader>rn', vim.lsp.buf.rename, opts)
  nnoremap('<C-h>', vim.lsp.buf.signature_help, opts)
end)

lsp.setup()

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = false,
  float = true,
})
