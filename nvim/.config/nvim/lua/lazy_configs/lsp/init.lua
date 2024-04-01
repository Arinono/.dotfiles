local M = {}

M.keymaps = require 'lazy_configs.lsp.keymaps'
M.autocmds = require 'lazy_configs.lsp.autocmds'
M.capabilities = require 'lazy_configs.lsp.capabilities'
M.servers = require 'lazy_configs.lsp.servers'

function M.setup_diagnostics()
  require 'lazy_configs.lsp.diagnostics'
end

return M
