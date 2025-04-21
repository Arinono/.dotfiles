local autocmd = vim.api.nvim_create_autocmd
local autogrp = vim.api.nvim_create_augroup

local otter_group = autogrp("Otter", {})

autocmd({ "BufEnter" }, {
  group = otter_group,
  pattern = { "javascript", "rust" },
  callback = function()
    local ft = vim.bo.filetype

    if ft == "rust" or ft == "javascript" then
      require("otter").activate({ "javascript", "rust" }, true, true, nil)
    end
  end,
  desc = "Activasted otter",
})
