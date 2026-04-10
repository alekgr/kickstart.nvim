local dap = require("dap")
local dapui = require("dapui")

-- 1. Initialize Virtual Text (for inline values)
require("nvim-dap-virtual-text").setup({
  commented = true, -- prefix virtual text with comment string
})

-- 2. Initialize DAP UI
dapui.setup()

-- 3. Automatic UI Toggling
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end


dap.adapters.codelldb = {
      type = 'executable',
      command = vim.fn.stdpath("data") .. '/mason/bin/codelldb',
      name = 'codelldb',
      configuration = {
        showDisassembly = 'never',
      },
}

dap.adapters.gdb = {
      id = 'gdb',
      type = 'executable',
      command = 'gdb',
      args = { '--quiet', '--interpreter=dap' },
}

dap.configurations.c = {
      {
        name = "1: launch 'main' (no args)",
        type = "codelldb",
        request = "launch",
        	cwd = '${workspaceFolder}',
	program = function()
    	local executable = vim.fn.expand('%:p:r')
    	if vim.fn.executable(executable) == 1 then
    		return executable
  	else
        		return vim.fn.input('Executable not found. Path: ', vim.fn.getcwd() .. '/', 'file')
  	end -- This end closes the if/else block
	end,
        stopOnEntry = false,
        showDisassembly = 'never',
	initCommands = {
  	  'settings set stop-disassembly-count 0',
          'settings set stop-disassembly-display never',
          'settings set target.process.stop-on-exec false',
          'settings set target.process.stop-on-sharedlibrary-events false',
	},
	SetupCommands = {
	  {
          	text = 'enable pretty printing',
          	description = 'enable pretty printing',
          	IgnoreFailures = true,
	  },
        },

      },
      {
	name = "2: Launch with Custom Args",
    	type = "codelldb",
    	request = "launch",
    	program = function()
      		return vim.fn.getcwd() .. '/main'
    	end,
    	args = function()
      		local args_string = vim.fn.input('Enter argv: ')
      		return vim.split(args_string, " +")
    	end,
    	cwd = '${workspaceFolder}',
    	stopOnEntry = false,
	initCommands = {
  	  'settings set stop-disassembly-count 0',
          'settings set stop-disassembly-display never',
          'settings set target.process.stop-on-exec false',
          'settings set target.process.stop-on-sharedlibrary-events false',
	},

	SetupCommands = {
	  {
          	text = 'enable pretty printing',
          	description = 'enable pretty printing',
          	IgnoreFailures = true,
	  },

        },

      },

      {
	name = "3: Manual Select (File & Args)",
    	type = "codelldb",
    	request = "launch",
    	program = function()
      		return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    	end,
    	args = function()
      		local args_string = vim.fn.input('Arguments: ')
      		return vim.split(args_string, " +")
    	end,
    	cwd = '${workspaceFolder}',
    	stopOnEntry = false,
	initCommands = {
  	  'settings set stop-disassembly-count 0',
          'settings set stop-disassembly-display never',
          'settings set target.process.stop-on-exec false',
          'settings set target.process.stop-on-sharedlibrary-events false',
	},

	SetupCommands = {
	  {
          	text = 'enable pretty printing',
          	description = 'enable pretty printing',
          	IgnoreFailures = true,
	  },
        },

      },

}

vim.keymap.set('n', '<leader>ds', function() dap.continue() end, { desc = "Debug: Start/Continue" })
vim.keymap.set('n', '<leader>do', function() dap.step_over() end, { desc = "Debug: Step Over" })
vim.keymap.set('n', '<leader>di', function() dap.step_into() end, { desc = "Debug: Step Into" })
vim.keymap.set('n', '<leader>du', function() dap.step_out() end, { desc = "Debug: Step Out" })
vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set('n', '<leader>b', function()
	dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, { desc = 'Debug: Set breakpoint' })
vim.keymap.set('n', '<leader>dr', function() dap.repl.open() end, { desc = "Debug: Open REPL" })
vim.keymap.set('n', '<Leader>dq', function()
  	require('dap').terminate()
  	require('dapui').close()
  	-- If using virtual text, you might also want to refresh here
  	-- require('dap_virtual_text').refresh() 
end, { desc = 'Quit DAP session and close UI' })
vim.keymap.set('n', '<leader>d', '<Cmd>lua require("dapui").toggle()<CR>', { desc = 'Debug: See last session result.' })
