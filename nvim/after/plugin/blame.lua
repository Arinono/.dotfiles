local nnoremap = require('arinono.keymap').nnoremap
local git_blame = require('gitblame')
local lualine = require('lualine')

vim.g.gitblame_enabled = 0
vim.g.gitblame_message_template = "<author> | <date> | <summary>"
vim.g.gitblame_message_when_not_committed = "not committed"
vim.g.gitblame_date_format = "%r"
vim.g.gitblame_display_virtual_text = 0

lualine.setup({
    sections = {
            lualine_x = {
                { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available }
            }
    }
})

nnoremap("<leader>boc", function() vim.call("GitBlameOpenCommitURL") end, { silent = false })
nnoremap("<leader>bof", function() vim.call("GitBlameOpenFileURL") end, { silent = false })
nnoremap("<leader>bcc", function() vim.call("GitBlameCopyCommitURL") end, { silent = false })
nnoremap("<leader>bcf", function() vim.call("GitBlameCopyFileURL") end, { silent = false })

