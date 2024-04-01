local M = {}

local _map = function(event)
  return function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
  end
end

function M.register(event)
  local map = _map(event)

  map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

  map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

  map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

  map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

  map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

  map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

  map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  map('K', vim.lsp.buf.hover, 'Hover Documentation')

  map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  map('<leader>sh', vim.lsp.buf.signature_help, '[S]ignature [H]elp')

  map('<leader>qf', function()
    vim.lsp.buf.code_action {
      apply = true,
    }
  end, '[Q]uick [F]ix')
end

return M
