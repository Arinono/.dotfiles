local nnoremap = require('arinono.keymap').nnoremap
local git_blame = require('gitblame')
local lualine = require('lualine')

vim.g.gitblame_enabled = 0
vim.g.gitblame_message_template = "<author> | <date> | <summary>"
vim.g.gitblame_message_when_not_committed = "🚫"
vim.g.gitblame_date_format = "%r"
vim.g.gitblame_display_virtual_text = 0

local show = false
local function update(text)
  lualine.setup({
    sections = {
      lualine_x = { text }
    }
  })

  lualine.refresh()
end

update("")

nnoremap("<leader>bt", function()
  vim.api.nvim_call_function("GitBlameToggle", {})

  if not show then
    update({
      git_blame.get_current_blame_text,
      cond = git_blame.is_blame_text_available,
    })
    show = true
  else
    update("")
    show = false
  end

end, { silent = false })

nnoremap("<leader>boc", function() vim.api.nvim_call_function("GitBlameOpenCommitURL", {}) end, { silent = false })
nnoremap("<leader>bof", function() vim.api.nvim_call_function("GitBlameOpenFileURL", {}) end, { silent = false })
nnoremap("<leader>bcc", function() vim.api.nvim_call_function("GitBlameCopyCommitURL", {}) end, { silent = false })
nnoremap("<leader>bcf", function() vim.api.nvim_call_function("GitBlameCopyFileURL", {}) end, { silent = false })
