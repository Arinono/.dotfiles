local nnoremap = require("arinono.keymap").nnoremap
local builtin = require('telescope.builtin')

-- all files
nnoremap("<leader>pf", builtin.find_files)

nnoremap("<leader>pF", function()
  builtin.find_files({ hidden = true })
end)

-- git files
nnoremap("<leader>pg", builtin.git_files)

nnoremap("<leader>pG", function()
  builtin.git_files({ hidden = true })
end)

-- greped files with input
nnoremap("<leader>ps", function()
  builtin.grep_string({ search = vim.fn.input("🔭 > ")})
end)

nnoremap("<leader>pls", builtin.live_grep)

-- greped files with word under cursor
nnoremap("<leader>pw", function()
    builtin.grep_string { search = vim.fn.expand("<cword>") }
end)

-- buffers
nnoremap("<leader>pb", builtin.buffers)

-- help tags
nnoremap("<leader>ht", builtin.help_tags)

nnoremap("<leader>sd", builtin.diagnostics)

nnoremap("<leader>pk", builtin.keymaps)
