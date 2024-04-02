local M = {}

function M.keymaps()
  local builtin = require("telescope.builtin")
  vim.keymap.set("n", "<leader>ph", builtin.help_tags, { desc = "[S]earch [H]elp" })
  vim.keymap.set("n", "<leader>pk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
  vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "[S]earch [F]iles" })
  vim.keymap.set("n", "<leader>pbi", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
  vim.keymap.set("n", "<leader>pw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
  vim.keymap.set("n", "<leader>pls", builtin.live_grep, { desc = "[S]earch by [G]rep" })
  vim.keymap.set("n", "<leader>pd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
  vim.keymap.set("n", "<leader>pr", builtin.resume, { desc = "[S]earch [R]esume" })
  vim.keymap.set("n", "<leader>pg", builtin.git_files, { desc = "[S]earch [G]it" })
  vim.keymap.set("n", "<leader>pbu", builtin.buffers, { desc = "[ ] Find existing buffers" })
  vim.keymap.set(
    "n",
    "<leader>p.",
    builtin.oldfiles,
    { desc = '[S]earch Recent Files ("." for repeat)' }
  )

  vim.keymap.set("n", "<leader>pF", function()
    builtin.find_files({ hidden = true })
  end, { desc = "[S]earch Hidden [F]iles" })

  vim.keymap.set("n", "<leader>ps", function()
    builtin.grep_string({ search = vim.fn.input("🔭 > ") })
  end)

  vim.keymap.set("n", "<leader>/", function()
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
      winblend = 10,
      previewer = false,
    }))
  end, { desc = "[/] Fuzzily search in current buffer" })

  vim.keymap.set("n", "<leader>s/", function()
    builtin.live_grep({
      grep_open_files = true,
      prompt_title = "Live Grep in Open Files",
    })
  end, { desc = "[S]earch [/] in Open Files" })

  vim.keymap.set("n", "<leader>pn", function()
    builtin.find_files({ cwd = vim.fn.stdpath("config") })
  end, { desc = "[S]earch [N]eovim files" })
end

function M.config()
  require("telescope").setup({
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown(),
      },
    },
  })

  pcall(require("telescope").load_extension, "fzf")
  pcall(require("telescope").load_extension, "ui-select")

  M.keymaps()
end

return M
