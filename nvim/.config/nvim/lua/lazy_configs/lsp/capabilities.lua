local M = {}

M.capabilities = vim.lsp.protocol.make_client_capabilities()

function M.add(mode, capabilities)
  M.capabilities = vim.tbl_deep_extend(mode, M.capabilities, capabilities)
end

return M
