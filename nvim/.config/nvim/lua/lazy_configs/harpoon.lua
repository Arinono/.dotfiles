local M = {}

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

local map = function(keys, func, desc)
  vim.keymap.set("n", keys, func, { desc = "[H]arpoon: " .. desc })
end

function M.config()
  local harpoon = require("harpoon")
  harpoon:setup({})

  map("<leader>hg", function()
    harpoon:list():append()
  end, "Re[G]ister")

  map("<C-e>", function()
    toggle_telescope(harpoon:list())
  end, "Open harpoon window")

  map("<leader>hh", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
  end, "Open harpoon window")

  map("<leader>ha", function()
    harpoon:list():select(1)
  end, "First")

  map("<leader>hs", function()
    harpoon:list():select(2)
  end, "Second")

  map("<leader>hd", function()
    harpoon:list():select(3)
  end, "Third")

  map("<leader>hf", function()
    harpoon:list():select(4)
  end, "Forth")
end

return M
