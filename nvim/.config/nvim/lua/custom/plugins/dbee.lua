return {
  "kndndrj/nvim-dbee",
  dependencies = { "MunifTanjim/nui.nvim" },
  build = function()
    require("dbee").install("go")
  end,
  config = function()
    local source = require("dbee.sources")
    require("dbee").setup({
      sources = {
        source.FileSource:new(vim.fn.stdpath("cache") .. "/dbee/persistence.json"),
      },
    })
    require("custom.dbee")
  end,
}
