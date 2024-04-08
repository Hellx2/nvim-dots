local dap = require("dap")
dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "-i", "dap" }
}

dap.configurations.rust = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
}

dap.configurations.cpp = {
    {
       name = "Launch",
       type = "gdb",
       request = "launch",
       program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
       end,
       cwd = '${workspaceFolder}',
       externalTerminal = false,
       stopOnEntry = false,
       args = {}
    },
}

local dapui = require("dapui")

dapui.setup()

require("neodev").setup({
  -- add any options here, or leave empty to use the default settings
  library = { plugins = { "nvim-dap-ui" }, types = true },
})

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

require("notify")("Successfully set up 'nvim-dap'", "info", {
    title = "Loaded nvim-dap"
})
