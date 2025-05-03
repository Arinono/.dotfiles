return {
  { "mxsdev/nvim-dap-vscode-js", requires = { "mfussenegger/nvim-dap" } },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
    },
    config = function()
      local dap = require("dap")
      local ui = require("dapui")

      require("dapui").setup()

      require("nvim-dap-virtual-text").setup({
        display_callback = function(variable)
          local name = string.lower(variable.name)
          local value = string.lower(variable.value)
          if
            name:match("secret")
            or name:match("api")
            or value:match("secret")
            or value:match("api")
          then
            return "*****"
          end

          if #variable.value > 15 then
            return " " .. string.sub(variable.value, 1, 15) .. "... "
          end

          return " " .. variable.value
        end,
      })

      require("dap-vscode-js").setup({
        debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
        debugger_cmd = { "js-debug-adapter" },
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      })

      local custom_adapter = "pwa-node-custom"
      for _, language in ipairs({ "typescript", "javascript" }) do
        dap.configurations[language] = {
          {
            name = "Launch",
            type = "node-terminal",
            request = "launch",
            program = "${file}",
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**" },
            protocol = "inspector",
            console = "integratedTerminal",
          },
          {
            name = "Attach to node process",
            type = "pwa-node",
            request = "attach",
            rootPath = "${workspaceFolder}",
            processId = require("dap.utils").pick_process,
          },
          {
            name = "Debug Main Process (Electron)",
            type = "pwa-node",
            request = "launch",
            program = "${workspaceFolder}/node_modules/.bin/electron",
            args = {
              "${workspaceFolder}/dist/index.js",
            },
            outFiles = {
              "${workspaceFolder}/dist/*.js",
            },
            resolveSourceMapLocations = {
              "${workspaceFolder}/dist/**/*.js",
              "${workspaceFolder}/dist/*.js",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**" },
            protocol = "inspector",
            console = "integratedTerminal",
          },
          {
            name = "Compile & Debug Main Process (Electron)",
            type = custom_adapter,
            request = "launch",
            preLaunchTask = "npm run build-ts",
            program = "${workspaceFolder}/node_modules/.bin/electron",
            args = {
              "${workspaceFolder}/dist/index.js",
            },
            outFiles = {
              "${workspaceFolder}/dist/*.js",
            },
            resolveSourceMapLocations = {
              "${workspaceFolder}/dist/**/*.js",
              "${workspaceFolder}/dist/*.js",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**" },
            protocol = "inspector",
            console = "integratedTerminal",
          },
        }
      end

      vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
      vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

      -- Eval var under cursor
      vim.keymap.set("n", "<space>?", function()
        require("dapui").eval(nil, { enter = true })
      end)

      vim.keymap.set("n", "<F1>", dap.continue)
      vim.keymap.set("n", "<F2>", dap.step_over)
      vim.keymap.set("n", "<F3>", dap.step_into)
      vim.keymap.set("n", "<F4>", dap.step_out)
      vim.keymap.set("n", "<F5>", dap.step_back)
      vim.keymap.set("n", "<F13>", dap.restart)

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },
}
