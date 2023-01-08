local nnoremap = require("arinono.keymap").nnoremap
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
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y'] = cmp.mapping.confirm({ select = true }),
  ['<C-Space'] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
  mappings = cmp_mappings
})

lsp.set_preferences({
  sign_icons = {
    error = "",
    warning = "⚠",
    info = "ⓘ",
  }
})

lsp.on_attach(function(_, buff)
  local opts = { buffer = buff, remap = false }

  nnoremap('gd', function() vim.lsp.buf.definitions() end, opts)
  nnoremap('K', function() vim.lsp.buf.hover() end, opts)
  nnoremap('<leader>vws', function() vim.lsp.buf.workspace_symbol() end, opts)
  nnoremap('<leader>vd', function() vim.lsp.diagnostic.open_float() end, opts)
  nnoremap('[d', function() vim.lsp.diagnostic.goto_next() end, opts)
  nnoremap('d]', function() vim.lsp.diagnostic.goto_prev() end, opts)
  nnoremap('<leader>vca', function() vim.lsp.buf.code_action() end, opts)
  nnoremap('gr', function() vim.lsp.buf.references() end, opts)
  nnoremap('<leader>rn', function() vim.lsp.buf.rename() end, opts)
  nnoremap('<C-h>', function() vim.lsp.buf.signature_help() end, opts)
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
