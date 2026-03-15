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
        name = 'Run executable  (codelldb)',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input {
            prompt = 'Path to executable',
            default = vim.fn.getcwd() .. '/',
            completion = 'file',
          }
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        showDisassembly = 'never',
        initCommands = {
          'settings set stop-disassembly-count 0',
          'settings set stop-disassembly-display never',
          'settings set target.process.stop-on-exec false',
          'settings set target.process.stop-on-sharedlibrary-events false',
          'settings set target.process.thread.step-avoid-libraries true',
        },
        SetupCommands = {
          text = 'enable pretty printing',
          description = 'enable pretty printing',
          IgnoreFailures = true,
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

    function cleanup_asm_buffers()
      vim.schedule(function()
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          local name = vim.api.nvim_buf_get_name(bufnr)
          -- CodeLLDB often opens assembly in buffers with these names
          if name:match 'disassembly' or name:match 'out of source' then
            vim.api.nvim_buf_delete(bufnr, { force = true })
          end
        end
        -- Also close DAP UI if you use it
        local ok, dapui = pcall(require, 'dapui')
        if ok then
          dapui.close()
        end
      end)
    end

    function shutdowndebugger()
      dapui.close()
      dap.disconnect()
      dap.close()

      vim.schedule(function()
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          local name = vim.api.nvim_buf_get_name(bufnr)
          if name:match 'disassembly' or name:match 'out of source' then
            vim.api.nvim_command('bwipeout! ' .. bufnr)
          end
        end
        if vim.bo.filetype == "" or vim.bo.filetype == "dapui_assembler" then
          vim.cmd("bnext")
        end
      end)
    end

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<leader>d', '<Cmd>lua require("dapui").toggle()<CR>', { desc = 'Debug: See last session result.' })
    vim.keymap.set('n', '<leader>dx', shutdowndebugger)

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
    dap.listeners.after.event_terminated['cleanup_asm'] = cleanup_asm_buffers
    dap.listeners.after.event_exited['cleanup_asm'] = cleanup_asm_buffers
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
