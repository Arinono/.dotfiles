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
        source.MemorySource:new({
          ---@diagnostic disable-next-line: missing-fields
          {
            type = "postgres",
            name = "w2k",
            url = "postgresql://postgres@127.0.0.1:5433/wuxia2kindle",
          },
        }, "w2k"),
        source.MemorySource:new({
          {
            type = "postgres",
            name = "wtg",
            url = "postgresql://postgres@127.0.0.1:5432/withthegrid_amp_develop",
          },
        }, "wtg"),
        -- source.MemorySource:new({
        --   ---@diagnostic disable-next-line: missing-fields
        --   {
        --     type = "postgres",
        --     name = "wtg_feat",
        --     url = "postgresql://postgres@127.0.0.1:5432/withthegrid_amp_develop_feature",
        --   },
        -- }, "wtg_feat"),
      },
    })
    require("custom.dbee")
  end,
}
