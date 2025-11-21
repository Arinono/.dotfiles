local function toggle_telescope(harpoon_files)
  local conf = require("telescope.config").values
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers")
      .new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
          results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
      })
      :find()
end

local function map(keys, func, desc)
  vim.keymap.set("n", keys, func, { desc = "[H]arpoon: " .. desc })
end

local function telescope_keymaps()
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
    builtin.grep_string({
      search = vim.fn.input("🔭 > "),
      use_regex = true,
    })
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

return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",

        build = "make",

        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },

      { "nvim-tree/nvim-web-devicons",            enabled = vim.g.have_nerd_font },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = { width = 0.9 },
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      telescope_keymaps()
    end,
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      save_on_toggle = true,
    },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({})

      map("<leader>a", function()
        harpoon:list():add()
      end, "Re[G]ister")

      map("<C-e>", function()
        toggle_telescope(harpoon:list())
      end, "Open harpoon window")

      map("<leader>hh", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, "Open harpoon window")

      map("<C-h>", function()
        harpoon:list():select(1)
      end, "First")

      map("<C-j>", function()
        harpoon:list():select(2)
      end, "Second")

      map("<C-k>", function()
        harpoon:list():select(3)
      end, "Third")

      map("<C-l>", function()
        harpoon:list():select(4)
      end, "Forth")
    end,
  },
}
