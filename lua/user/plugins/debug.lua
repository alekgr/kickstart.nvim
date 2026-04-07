-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  config = function() end,
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- virutal text
    'theHamsta/nvim-dap-virtual-text',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  opts = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
        'codelldb',
      },
    }

    dap.defaults.fallback.exception_breakpoints = {}

    dap.adapters.lldb = {
      type = 'executable',
      command = '/usr/bin/lldb-dap',
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
        program = function()
          	return vim.fn.getcwd() .. '/main'
        end,
	cwd = '${workspaceFolder}',
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
    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<leader>ds', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<leader>du', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })
    vim.keymap.set('n', '<Leader>dq', function()
  	require('dap').terminate()
  	require('dapui').close()
  	-- If using virtual text, you might also want to refresh here
  	-- require('dap_virtual_text').refresh() 
	end, { desc = 'Quit DAP session and close UI' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<leader>d', '<Cmd>lua require("dapui").toggle()<CR>', { desc = 'Debug: See last session result.' })

    vim.keymap.set('n', '<leader>dc', function()
  	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    		local name = vim.api.nvim_buf_get_name(buf)
    		if name:match("DAP Disassembly") or name:match("!lldb") then
      			vim.api.nvim_buf_delete(buf, { force = true })
    		end
  	end
  	print("Assembly buffer cleared.")
    end, { desc = 'Clear assembly buffer but keep session' })


    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.after.event_terminated['dapui_config'] = function()
    	dapui.close()
    	dap.terminate()
    end
    dap.listeners.after.event_exited['dapui_config'] = function()
	    dapui.close()
	    dap.terminate()
    end

    -- dap.listeners.after.event_terminated['cleanup'] = fully_terminate
    -- dap.listeners.after.event_exited['cleanup'] = fully_terminate

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
