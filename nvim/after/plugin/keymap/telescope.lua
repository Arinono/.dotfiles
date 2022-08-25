local nnoremap = require("arinono.keymap").nnoremap

-- all files
nnoremap("<leader>pf", function()
  require("telescope.builtin").find_files()
end)

nnoremap("<leader>pF", function()
  require("telescope.builtin").find_files({ hidden = true })
end)

-- git files
nnoremap("<leader>pg", function()
  require("telescope.builtin").git_files()
end)

nnoremap("<leader>pG", function()
  require("telescope.builtin").git_files({ hidden = true })
end)

-- greped files with input
nnoremap("<leader>ps", function()
  require('telescope.builtin').grep_string({ search = vim.fn.input("🔭 > ")})
end)

-- greped files with word under cursor
nnoremap("<leader>pw", function()
    require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }
end)

-- buffers
nnoremap("<leader>pb", function()
  require("telescope.builtin").buffers()
end)

-- help tags
nnoremap("<leader>ht", function()
  require("telescope.builtin").help_tags()
end)
