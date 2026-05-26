return {
  "kndndrj/nvim-dbee",
  dependencies = { "MunifTanjim/nui.nvim" },
  build = function()
    require("dbee").install("go")
  end,
  config = function()
    local source = require("dbee.sources")
    require("dbee").setup({
      default_connection = "wtg",
      sources = {
        source.FileSource:new(vim.fn.stdpath("cache") .. "/dbee/persistence.json"),
      },
    })
    vim.keymap.set("n", "<space>od", function()
      require("dbee").open()
    end, { desc = "[O]pen [D]Bee" })
    require("custom.dbee")
  end,
}
