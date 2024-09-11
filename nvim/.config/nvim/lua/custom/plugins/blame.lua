return {
  "FabijanZulj/blame.nvim",
  opts = {
    blame_options = { "-w" },
  },
  keys = {
    {
      "<C-q>",
      ":BlameToggle<CR>",
      mode = "n",
      desc = "[G]it [B]lame",
    },
  },
}
