return {
  --   "greggh/claude-code.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim", -- Required for git operations
  --   },
  --   lazy = true,
  --   config = function()
  --     require("claude-code").setup({
  --       window = {
  --         split_ratio = 0.5,
  --         position = "vsplit",
  --         enter_insert = false,
  --       },
  --     })
  --   end,
  --   keys = {
  --     {
  --       "<leader>cc",
  --       "<cmd>ClaudeCode<cr>",
  --       mode = "n",
  --       desc = "[C]laude [C]ode",
  --     },
  --   },
  -- {
  --   "supermaven-inc/supermaven-nvim",
  --   config = function()
  --     require("supermaven-nvim").setup({
  --       keymaps = {
  --         accept_suggestion = "<Tab>",
  --         clear_suggestion = "<C-]>",
  --         accept_word = "<C-j>",
  --       }
  --     })
  --   end,
  -- }
  {
    "ThePrimeagen/99",
    config = function()
      local _99 = require("99")

      _99.setup({
        model = "anthropic/claude-opus-4-5",
        md_files = {
          "AGENTS.md",
        },
        completion = {
          custom_rules = {
            "~/skills/",
          },
          source = "cmp",
        },
      })
      vim.keymap.set("n", "<leader>9ff", function()
        _99.fill_in_function()
      end)
      vim.keymap.set("n", "<leader>9fp", function()
        _99.fill_in_function_prompt()
      end)
      vim.keymap.set("n", "<leader>9fd", function()
        _99.fill_in_function({
          additional_rules = {
            _99:rule_from_path("~/.99/debug.md"),
          },
        })
      end)
      vim.keymap.set("v", "<leader>9vv", function()
        _99.visual()
      end)
      vim.keymap.set("v", "<leader>9vp", function()
        _99.visual_prompt()
      end)
      vim.keymap.set("n", "<leader>9s", function()
        _99.stop_all_requests()
      end)

      vim.keymap.set("n", "<leader>9i", function()
        _99.info()
      end)
      vim.keymap.set("n", "<leader>9l", function()
        _99.view_logs()
      end)
    end,
  }
}
