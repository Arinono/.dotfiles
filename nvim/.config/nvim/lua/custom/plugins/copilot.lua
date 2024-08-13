return {
  "github/copilot.vim",
  config = function()
    vim.g.copilot_no_tabs_map = true
    vim.g.copilot_enabled = false

    vim.keymap.set(
      "i",
      "<C-\\>",
      'copilot#Accept("<CR>")',
      { silent = true, expr = true, noremap = true, replace_keycodes = false }
    )
  end,
}
