local M = {}

function M.config()
  vim.g.copilot_no_tabs_map = true
  vim.g.copilot_enabled = true

  vim.keymap.set(
    "i",
    "<leader>\\",
    'copilot#Accept("<CR>")',
    { silent = true, expr = true, noremap = true, replace_keycodes = false }
  )
end

return M
